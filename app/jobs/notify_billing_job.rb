class NotifyBillingJob < ApplicationJob
  queue_as :default

  before_perform do |job|
    current_billing = job.arguments.first
    next_billing = current_billing.subscription.billings.create!(
      billing_date: current_billing.billing_date + 1.month, amount: 19.90
    )
    self.class.set(wait_until: next_billing.billing_date.to_datetime).perform_later(next_billing)
  end

  def perform(billing)
    BillingsMailer.with(billing:).notify_billing.deliver
  end
end
