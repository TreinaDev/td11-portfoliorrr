class PostSchedulerJob < ApplicationJob
  queue_as :default

  def perform(post)
    post.published!
  end
end
