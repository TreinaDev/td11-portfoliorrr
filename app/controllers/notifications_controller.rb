class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.profile.notifications.order(created_at: :desc)
    @notifications.update_all(read: true)
  end
end
