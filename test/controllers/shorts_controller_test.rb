require "test_helper"

class ShortsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @short = shorts(:one)
  end

  test "should get index" do
    get shorts_url
    assert_response :success
  end

  test "should get new" do
    get new_short_url
    assert_response :success
  end

  test "should create short" do
    assert_difference("Short.count") do
      post shorts_url, params: { short: { game_id: @short.game_id, result: @short.result } }
    end

    assert_redirected_to short_url(Short.last)
  end

  test "should show short" do
    get short_url(@short)
    assert_response :success
  end

  test "should get edit" do
    get edit_short_url(@short)
    assert_response :success
  end

  test "should update short" do
    patch short_url(@short), params: { short: { game_id: @short.game_id, result: @short.result } }
    assert_redirected_to short_url(@short)
  end

  test "should destroy short" do
    assert_difference("Short.count", -1) do
      delete short_url(@short)
    end

    assert_redirected_to shorts_url
  end
end
