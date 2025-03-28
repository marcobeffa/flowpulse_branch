require "test_helper"

class ExternalPostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @external_post = external_posts(:one)
  end

  test "should get index" do
    get external_posts_url
    assert_response :success
  end

  test "should get new" do
    get new_external_post_url
    assert_response :success
  end

  test "should create external_post" do
    assert_difference("ExternalPost.count") do
      post external_posts_url, params: { external_post: { branch_id: @external_post.branch_id, content: @external_post.content, profile: @external_post.profile, slug: @external_post.slug } }
    end

    assert_redirected_to external_post_url(ExternalPost.last)
  end

  test "should show external_post" do
    get external_post_url(@external_post)
    assert_response :success
  end

  test "should get edit" do
    get edit_external_post_url(@external_post)
    assert_response :success
  end

  test "should update external_post" do
    patch external_post_url(@external_post), params: { external_post: { branch_id: @external_post.branch_id, content: @external_post.content, profile: @external_post.profile, slug: @external_post.slug } }
    assert_redirected_to external_post_url(@external_post)
  end

  test "should destroy external_post" do
    assert_difference("ExternalPost.count", -1) do
      delete external_post_url(@external_post)
    end

    assert_redirected_to external_posts_url
  end
end
