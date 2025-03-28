require "application_system_test_case"

class ExternalPostsTest < ApplicationSystemTestCase
  setup do
    @external_post = external_posts(:one)
  end

  test "visiting the index" do
    visit external_posts_url
    assert_selector "h1", text: "External posts"
  end

  test "should create external post" do
    visit external_posts_url
    click_on "New external post"

    fill_in "Branch", with: @external_post.branch_id
    fill_in "Content", with: @external_post.content
    fill_in "Profile", with: @external_post.profile
    fill_in "Slug", with: @external_post.slug
    click_on "Create External post"

    assert_text "External post was successfully created"
    click_on "Back"
  end

  test "should update External post" do
    visit external_post_url(@external_post)
    click_on "Edit this external post", match: :first

    fill_in "Branch", with: @external_post.branch_id
    fill_in "Content", with: @external_post.content
    fill_in "Profile", with: @external_post.profile
    fill_in "Slug", with: @external_post.slug
    click_on "Update External post"

    assert_text "External post was successfully updated"
    click_on "Back"
  end

  test "should destroy External post" do
    visit external_post_url(@external_post)
    click_on "Destroy this external post", match: :first

    assert_text "External post was successfully destroyed"
  end
end
