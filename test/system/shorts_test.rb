require "application_system_test_case"

class ShortsTest < ApplicationSystemTestCase
  setup do
    @short = shorts(:one)
  end

  test "visiting the index" do
    visit shorts_url
    assert_selector "h1", text: "Shorts"
  end

  test "should create short" do
    visit shorts_url
    click_on "New short"

    fill_in "Game", with: @short.game_id
    check "Result" if @short.result
    click_on "Create Short"

    assert_text "Short was successfully created"
    click_on "Back"
  end

  test "should update Short" do
    visit short_url(@short)
    click_on "Edit this short", match: :first

    fill_in "Game", with: @short.game_id
    check "Result" if @short.result
    click_on "Update Short"

    assert_text "Short was successfully updated"
    click_on "Back"
  end

  test "should destroy Short" do
    visit short_url(@short)
    click_on "Destroy this short", match: :first

    assert_text "Short was successfully destroyed"
  end
end
