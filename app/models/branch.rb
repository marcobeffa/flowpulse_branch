# == Schema Information
#
# Table name: branches
#
#  id                 :integer          not null, primary key
#  user_id            :integer          not null
#  slug               :string
#  parent_id          :integer
#  position           :integer
#  updated_content    :datetime
#  slug_note          :string
#  user_note_username :string
#  child_id           :integer
#  mycategory_id      :integer          not null Eliminata
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_branches_on_mycategory_id  (mycategory_id) Eliminata
#  index_branches_on_user_id        (user_id)
#

class Branch < ApplicationRecord
  belongs_to :user
  belongs_to :mycategory, optional: true
  has_one :external_post, dependent: :destroy

  has_many :category, through: :mycategory

  # Gerarchia dell'albero (Parent-Child)
  belongs_to :parent, class_name: "Branch", foreign_key: "parent_id", optional: true
  has_many :children, class_name: "Branch", foreign_key: "parent_id", dependent: :nullify

  # Collegamenti tra rami separati
  belongs_to :child_link, class_name: "Branch", foreign_key: "child_id", optional: true
  has_many :parent_links, class_name: "Branch", foreign_key: "child_id", dependent: :nullify


  # Gestisce l'ordine tra i figli dello stesso parent
  acts_as_list scope: :parent_id


  # Validazioni
  validates :slug, presence: true

  #  validates :slug_note, uniqueness: true, allow_nil: true
  #
  ## Enum per visibilità (iscritti: 2 = iscritti tutto nascosto ai non iscritti, pubblico_menu)
  enum :visibility, { 
    privato: 0, 
    iscritto: 1, 
    loggato: 2,
    pubblico: 3
   }
  enum :field_type, {
  string: 0,
  text: 1,
  integer: 2,
  float: 3,
  decimal: 4,
  boolean: 5,
  date: 6,
  time: 7,
  datetime: 8,
  json: 9,
  jsonb: 10
}

  # Enum per stato
  enum :stato, {
    bozza: 0,          # La nota è un'idea iniziale
    organizzata: 1,     # La nota è stata organizzata per argomento
    corretto: 2        # La nota è stata strutturata in modo logico
  }
  VISIBILITY_ICONS = {
    "privato" => "🔒",
    "iscritto" => "🎟️",
    "loggato" => "👩🏻‍💻",
    "pubblico" => "🌍"
  }

  def visibility_icon
    VISIBILITY_ICONS[visibility]
  end
  def content_icon
    
    case self.content.nil?
    when false
      "📄✔️"
    when true
      "✍🏻💤"
    end
   
  end
  def published_icon
    published ? "✅" : "🚫"
  end
  def root
    self.class.where(id: self_and_ancestors_ids.first).first
  end

  def safe_parent
    Branch.find_by(id: parent_id)
  end

  def safe_link_child
    Branch.find_by(id: child_id)
  end

  def self_and_ancestors_ids
    ids = []
    current = self

    while current
      ids.unshift(current.id)
      current = current.parent
    end

    ids
  end
end
