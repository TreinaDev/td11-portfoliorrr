class PostInterestNotificationJob < ApplicationJob
  queue_as :default

  def perform(comment)
    post = comment.post
    users = post.comments.map(&:user).uniq.excluding(comment.user, post.user)
    users.each { |user| Notification.create!(profile: user.profile, notifiable: comment) }
  end
end
