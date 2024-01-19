class Profile < ApplicationRecord
  belongs_to :user
  has_one :personal_info, dependent: :destroy
end
