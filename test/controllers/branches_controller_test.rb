require "test_helper"

class BranchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @branch = branches(:one)
  end

  # test "should get index" do
  #   get branches_url
  #   assert_response :success
  # end

  # test "should get new" do
  #   get new_branch_url
  #   assert_response :success
  # end

  # test "should create branch" do
  #   assert_difference("Branch.count") do
  #     post branches_url, params: { branch: { child_id: @branch.child_id, mycategory_id: @branch.mycategory_id, content_id: @branch.content_id, parent_id: @branch.parent_id, slug: @branch.slug, slug_note: @branch.slug_note, user_id: @branch.user_id, user_note_username: @branch.user_note_username } }
  #   end

  #   assert_redirected_to branch_url(Branch.last)
  # end

  # test "should show branch" do
  #   get branch_url(@branch)
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get edit_branch_url(@branch)
  #   assert_response :success
  # end

  # test "should update branch" do
  #   patch branch_url(@branch), params: { branch: { child_id: @branch.child_id, mycategory_id: @branch.mycategory_id, content_id: @branch.content_id, parent_id: @branch.parent_id, slug: @branch.slug, slug_note: @branch.slug_note, user_id: @branch.user_id, user_note_username: @branch.user_note_username } }
  #   assert_redirected_to branch_url(@branch)
  # end

  # test "should destroy branch" do
  #   assert_difference("Branch.count", -1) do
  #     delete branch_url(@branch)
  #   end

  #   assert_redirected_to branches_url
  # end
end
