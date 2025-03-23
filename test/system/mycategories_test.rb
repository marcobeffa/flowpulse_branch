require "application_system_test_case"

class MycategoriesTest < ApplicationSystemTestCase
  setup do
    @mycategory = mycategories(:one)
  end

  # test "visiting the index" do
  #   visit mycategories_url
  #   assert_selector "h1", text: "Mycategories"
  # end

  # test "should create mycategory" do
  #   visit mycategories_url
  #   click_on "New mycategory"

  #   fill_in "Category", with: @mycategory.category_id
  #   fill_in "Description", with: @mycategory.description
  #   fill_in "Name", with: @mycategory.name
  #   check "Public" if @mycategory.public
  #   fill_in "User", with: @mycategory.user_id
  #   click_on "Create Mycategory"

  #   assert_text "Mycategory was successfully created"
  #   click_on "Back"
  # end

  # test "should update Mycategory" do
  #   visit mycategory_url(@mycategory)
  #   click_on "Edit this mycategory", match: :first

  #   fill_in "Category", with: @mycategory.category_id
  #   fill_in "Description", with: @mycategory.description
  #   fill_in "Name", with: @mycategory.name
  #   check "Public" if @mycategory.public
  #   fill_in "User", with: @mycategory.user_id
  #   click_on "Update Mycategory"

  #   assert_text "Mycategory was successfully updated"
  #   click_on "Back"
  # end

  # test "should destroy Mycategory" do
  #   visit mycategory_url(@mycategory)
  #   click_on "Destroy this mycategory", match: :first

  #   assert_text "Mycategory was successfully destroyed"
  # end
end
