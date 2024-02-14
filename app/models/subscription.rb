class Subscription < ApplicationRecord
  belongs_to :user
  enum status: { inative: 0, active: 10 }

  def active!
    self.start_date = Time.zone.now.to_date
    super
  end

  def inactive!
    self.start_date = nil
    super
  end
end
