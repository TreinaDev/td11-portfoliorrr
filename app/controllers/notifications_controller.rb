class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.profile.notifications.order(created_at: :desc)
    @notifications.map { |n| n.seen! if n.unseen? }
  end

  def update
    notification = Notification.find(params[:id])
    notification.clicked!
    redirect_to NotificationStrategy.new(notification).redirect_after_click
  end
end
