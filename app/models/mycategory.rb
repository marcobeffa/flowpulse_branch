# == Schema Information
#
# Table name: mycategories
#
#  id          :integer          not null, primary key
#  user_id     :integer          not null
#  category_id :integer
#  name        :string
#  icon        :string
#  description :text
#  public      :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_mycategories_on_category_id  (category_id)
#  index_mycategories_on_user_id      (user_id)
#

class Mycategory < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true
  has_many :branches



  validates :name, presence: true,
                   format: { with: /\A[a-z_]+\z/, message: "può contenere solo lettere minuscole e trattini bassi" }

  validates :description, presence: true
end
