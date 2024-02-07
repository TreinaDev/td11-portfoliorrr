class PostSchedulerJob < ApplicationJob
  queue_as :default

  def perform(post)
    post.published!
    post.update(published_at: Time.zone.now)
  end
end
