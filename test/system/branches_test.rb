require "application_system_test_case"

class BranchesTest < ApplicationSystemTestCase
  setup do
    @branch = branches(:one)
  end

  # test "visiting the index" do
  #   visit branches_url
  #   assert_selector "h1", text: "Branches"
  # end

  # test "should create branch" do
  #   visit branches_url
  #   click_on "New branch"

  #   fill_in "Child", with: @branch.child_id
  #   fill_in "Mycategory", with: @branch.mycategory_id
  #   fill_in "Note", with: @branch.updated_content
  #   fill_in "Parent", with: @branch.parent_id
  #   fill_in "Slug", with: @branch.slug
  #   fill_in "Slug note", with: @branch.slug_note
  #   fill_in "User", with: @branch.user_id
  #   fill_in "User note username", with: @branch.user_note_username
  #   click_on "Create Branch"

  #   assert_text "Branch was successfully created"
  #   click_on "Back"
  # end

  # test "should update Branch" do
  #   visit branch_url(@branch)
  #   click_on "Edit this branch", match: :first

  #   fill_in "Child", with: @branch.child_id
  #   fill_in "Mycategory", with: @branch.mycategory_id
  #   fill_in "Note", with: @branch.updated_content
  #   fill_in "Parent", with: @branch.parent_id
  #   fill_in "Slug", with: @branch.slug
  #   fill_in "Slug note", with: @branch.slug_note
  #   fill_in "User", with: @branch.user_id
  #   fill_in "User note username", with: @branch.user_note_username
  #   click_on "Update Branch"

  #   assert_text "Branch was successfully updated"
  #   click_on "Back"
  # end

  # test "should destroy Branch" do
  #   visit branch_url(@branch)
  #   click_on "Destroy this branch", match: :first

  #   assert_text "Branch was successfully destroyed"
  # end
end
