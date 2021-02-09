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
    if current_user.patient?
      current_user.video_calls 
    elsif current_user.provider?
      policy_scope(VideoCall).all.order(created_at: :asc) 
    else
      []
    end
  end
end
