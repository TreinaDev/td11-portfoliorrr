class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.profile.notifications.order(created_at: :desc)
    @notifications.map { |n| n.seen! if n.unseen? }
  end

  def update
    @notification = Notification.find(params[:id])
    @notification.clicked!
    redirect_to_notification
  end

  private

  def redirect_to_notification
    return redirect_to_invitation if @notification.notifiable.is_a? Invitation
    return redirect_to_comment if @notification.notifiable.is_a? Comment
    return redirect_to_connection if @notification.notifiable.is_a? Connection
    return redirect_to_post if @notification.notifiable.is_a? Post

    redirect_to_like if @notification.notifiable.is_a? Like
  end

  def redirect_to_invitation
    redirect_to invitation_path(@notification.notifiable)
  end

  def redirect_to_comment
    redirect_to post_path(@notification.notifiable.post)
  end

  def redirect_to_connection
    redirect_to profile_path(@notification.notifiable.follower)
  end

  def redirect_to_post
    redirect_to post_path(@notification.notifiable)
  end

  def redirect_to_like
    likeable = @notification.notifiable.likeable
    redirect_to post_path(likeable.is_a?(Comment) ? likeable.post : likeable)
  end
end
