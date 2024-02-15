class Subscription < ApplicationRecord
  SUBSCRIPTION_AMOUNT = 19.90
  belongs_to :user
  has_many :billings, dependent: :destroy

  enum status: { inactive: 0, active: 10 }

  after_update :create_billing, if: :active? && :saved_change_to_status?

  def active!
    self.start_date = Time.zone.now.to_date
    super
  end

  def inactive!
    self.start_date = nil
    super
  end

  private

  def create_billing
    return if start_date.nil?

    billing_date = if start_date.day < 29
                     start_date + 1.month
                   else
                     start_date.next_month.beginning_of_month + 1.month
                   end

    billings.create(billing_date:, amount: SUBSCRIPTION_AMOUNT)
  end
end
