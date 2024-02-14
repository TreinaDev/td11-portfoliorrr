class Subscription < ApplicationRecord
  belongs_to :user
  has_many :billings, dependent: :destroy

  enum status: { inactive: 0, active: 10 }

  after_update :enqueue_billing_job, if: :active? && :saved_change_to_status?

  def active!
    self.start_date = Time.zone.now
    super
  end

  def inactive!
    self.start_date = nil
    super
  end

  private

  def enqueue_billing_job
    billing_date = start_date.to_datetime + 1.month
    BillingJob.set(wait_until: billing_date).perform_later(self)
  end
end
