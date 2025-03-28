# == Schema Information
#
# Table name: branches
#
#  id                 :integer          not null, primary key
#  user_id            :integer          not null
#  slug               :string
#  parent_id          :integer
#  position           :integer
#  content_id         :integer
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

  has_many :category, through: :mycategory

  # Gerarchia dell'albero (Parent-Child)
  belongs_to :parent, class_name: "Branch", foreign_key: "parent_id", optional: true
  has_many :children, class_name: "Branch", foreign_key: "parent_id", dependent: :nullify

  # Collegamenti tra rami separati
  belongs_to :link_child, class_name: "Branch", foreign_key: "child_id", optional: true
  has_one :linked_parent, class_name: "Branch", foreign_key: "child_id", dependent: :nullify

  # Gestisce l'ordine tra i figli dello stesso parent
  acts_as_list scope: :parent_id

  # Validazioni
  validates :slug, presence: true
  validates :icon, presence: true
  #  validates :slug_note, uniqueness: true, allow_nil: true
  #
  ## Enum per visibilità
  enum :visibility, { privato: 0, iscritti: 1, pubblico: 2 }

  # Enum per stato
  enum :stato, {
    bozza: 0,          # La nota è un'idea iniziale
    organizzata: 1,     # La nota è stata organizzata per argomento
    corretto: 2        # La nota è stata strutturata in modo logico
  }
  scope :published, -> { where(published: true) }
  def root
    self.class.where(id: self_and_ancestors_ids.first).first
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
