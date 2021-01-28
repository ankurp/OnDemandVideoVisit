class DashboardController < ApplicationController
  before_action :set_dashboard

  def show
    if current_user.admin?
      redirect_to admin_root_path
    else
      render current_user.user_role
    end
  end

  private

  def set_dashboard
    @dashboard = Dashboard.new(current_user, video_calls)
  end

  def video_calls
    return current_user.video_calls if current_user.patient?
    return policy_scope(VideoCall).all.order(created_at: :asc) if current_user.provider?

    []
  end
end
