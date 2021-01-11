class Dashboard
  attr_reader :user, :video_calls

  def initialize(user, video_calls)
    @user = user
    @video_calls = video_calls
  end
end
