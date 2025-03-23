require "test_helper"

class TreesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get trees_index_url
    assert_response :success
  end

  test "should get show" do
    get trees_show_url
    assert_response :success
  end
end
