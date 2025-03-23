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
#  mycategory_id      :integer          not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_branches_on_mycategory_id  (mycategory_id)
#  index_branches_on_user_id        (user_id)
#

require "test_helper"

class BranchTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
