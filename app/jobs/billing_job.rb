class BillingJob < ApplicationJob
  queue_as :default

  def perform(subscription)
    subscription.billings.create(amount: 19.90)
  end
end
