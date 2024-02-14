class Billing < ApplicationRecord
  belongs_to :subscription

  before_create :set_billing_date

  private

  def set_billing_date
    return self.billing_date = subscription.start_date if subscription.start_date.day < 29

    self.billing_date = subscription.start_date.next_month.beginning_of_month
  end
end
