class Notification < ApplicationRecord
  belongs_to :profile
  belongs_to :notifiable, polymorphic: true
end
