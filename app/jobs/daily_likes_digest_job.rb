class DailyLikesDigestJob < ApplicationJob
  ONE_DAY = 1
  queue_as :default

  before_perform do |job|
    self.class.set(wait_until: Date.tomorrow.noon).perform_later(job.arguments.first)
  end

  def perform(user:)
    return if user.received_zero_likes?(ONE_DAY)
    
    LikesMailer.with(user:).notify_like.deliver
  end
end
