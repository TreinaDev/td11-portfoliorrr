class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.profile.notifications.order(created_at: :desc)
  end

  def mark_as_read
    @notification = Notification.find(params[:id])
    @notification.update(read_at: Time.zone.now)
    redirect_to request.referer
  end
end
