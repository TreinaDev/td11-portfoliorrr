class Profile < ApplicationRecord
  belongs_to :user
  has_one :personal_info, dependent: :destroy

  accepts_nested_attributes_for :personal_info

  after_create :create_personal_info!
end
