class Notification < ApplicationRecord
  belongs_to :profile
  belongs_to :notifiable, polymorphic: true

  enum status: { unseen: 0, seen: 5, clicked: 10 }
end
