require "test_helper"

class VideoCallsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @video_call = video_calls(:one)
  end

  test "should get index" do
    get video_calls_url
    assert_response :success
  end

  test "should get new" do
    get new_video_call_url
    assert_response :success
  end

  test "should create video_call" do
    assert_difference('VideoCall.count') do
      post video_calls_url, params: { video_call: { name: @video_call.name } }
    end

    assert_redirected_to video_call_url(VideoCall.last)
  end

  test "should show video_call" do
    get video_call_url(@video_call)
    assert_response :success
  end

  test "should get edit" do
    get edit_video_call_url(@video_call)
    assert_response :success
  end

  test "should update video_call" do
    patch video_call_url(@video_call), params: { video_call: { name: @video_call.name } }
    assert_redirected_to video_call_url(@video_call)
  end

  test "should destroy video_call" do
    assert_difference('VideoCall.count', -1) do
      delete video_call_url(@video_call)
    end

    assert_redirected_to video_calls_url
  end
end
