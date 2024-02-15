class PostSchedulerJob < ApplicationJob
  queue_as :default

  def perform(post)
    return if post.published?

    post.published!
  end
end
