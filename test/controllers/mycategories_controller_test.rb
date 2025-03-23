require "test_helper"

class MycategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mycategory = mycategories(:one)
  end

  # test "should get index" do
  #   get mycategories_url
  #   assert_response :success
  # end

  # test "should get new" do
  #   get new_mycategory_url
  #   assert_response :success
  # end

  # test "should create mycategory" do
  #   assert_difference("Mycategory.count") do
  #     post mycategories_url, params: { mycategory: { category_id: @mycategory.category_id, description: @mycategory.description, name: @mycategory.name, public: @mycategory.public, user_id: @mycategory.user_id } }
  #   end

  #   assert_redirected_to mycategory_url(Mycategory.last)
  # end

  # test "should show mycategory" do
  #   get mycategory_url(@mycategory)
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get edit_mycategory_url(@mycategory)
  #   assert_response :success
  # end

  # test "should update mycategory" do
  #   patch mycategory_url(@mycategory), params: { mycategory: { category_id: @mycategory.category_id, description: @mycategory.description, name: @mycategory.name, public: @mycategory.public, user_id: @mycategory.user_id } }
  #   assert_redirected_to mycategory_url(@mycategory)
  # end

  # test "should destroy mycategory" do
  #   assert_difference("Mycategory.count", -1) do
  #     delete mycategory_url(@mycategory)
  #   end

  #   assert_redirected_to mycategories_url
  # end
end
