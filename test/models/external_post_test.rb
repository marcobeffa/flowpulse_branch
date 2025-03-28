# == Schema Information
#
# Table name: external_posts
#
#  id            :integer          not null, primary key
#  branch_id     :integer          not null
#  api_variabile :string
#  content       :json
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_external_posts_on_branch_id  (branch_id)
#

require "test_helper"

class ExternalPostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
