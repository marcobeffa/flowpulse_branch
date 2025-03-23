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

require "test_helper"

class MycategoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
