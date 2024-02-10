class PostInterestNotificationJob < ApplicationJob
  queue_as :default

  def perform(comment)
    Rails.logger.debug '------------------------------------'
    Rails.logger.debug 'Iniciando o Job de post de interesse'
    post = comment.post
    users = post.comments.map(&:user).uniq.excluding(comment.user, post.user)
    users.each { |user| Notification.create!(profile: user.profile, notifiable: comment) }
    Rails.logger.debug 'Finalizando o Job de post de interesse'
  end
end
