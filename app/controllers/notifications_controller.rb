class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.profile.notifications
  end
end
