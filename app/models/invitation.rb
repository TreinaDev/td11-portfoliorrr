class Invitation < ApplicationRecord
  belongs_to :profile

  enum status: { pending: 0, accepted: 1, declined: 2, cancelled: 3, expired: 4, removed: 5 }
end
