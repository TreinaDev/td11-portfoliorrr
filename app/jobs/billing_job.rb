class BillingJob < ApplicationJob
  queue_as :default

  def perform(subscription, billing_date)
    subscription.billings.create(amount: 19.90, billing_date:)
  end
end
