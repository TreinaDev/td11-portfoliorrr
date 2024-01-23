class Profile < ApplicationRecord
  belongs_to :user
  has_one :personal_info, dependent: :destroy
  has_many :professional_infos, dependent: :destroy

  accepts_nested_attributes_for :personal_info
  accepts_nested_attributes_for :professional_infos

  after_create :create_personal_info!
end
