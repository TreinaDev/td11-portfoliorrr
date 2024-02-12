class NewPostNotificationJob < ApplicationJob
  def perform(post)
    post.user.profile.connections.each do |connection|
      Notification.create(profile: connection.follower, notifiable: post)
    end
  end
end
