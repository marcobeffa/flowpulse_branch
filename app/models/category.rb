# == Schema Information
#
# Table name: categories
#
#  id          :integer          not null, primary key
#  name        :string
#  icon        :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Category < ApplicationRecord
  has_many :mycategories
  validates :name, presence: true, uniqueness: true,
                   format: { with: /\A[a-z_]+\z/, message: "può contenere solo lettere minuscole e trattini bassi" }

  validates :description, presence: true
  def copied_to_mycategory?
    Mycategory.exists?(category_id: self.id)
  end
end
