require "application_system_test_case"

class VideoCallsTest < ApplicationSystemTestCase
  setup do
    @video_call = video_calls(:one)
  end

  test "visiting the index" do
    visit video_calls_url
    assert_selector "h1", text: "Video Calls"
  end

  test "creating a Video call" do
    visit video_calls_url
    click_on "New Video Call"

    fill_in "Name", with: @video_call.name
    click_on "Create Video call"

    assert_text "Video call was successfully created"
    click_on "Back"
  end

  test "updating a Video call" do
    visit video_calls_url
    click_on "Edit", match: :first

    fill_in "Name", with: @video_call.name
    click_on "Update Video call"

    assert_text "Video call was successfully updated"
    click_on "Back"
  end

  test "destroying a Video call" do
    visit video_calls_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Video call was successfully destroyed"
  end
end
