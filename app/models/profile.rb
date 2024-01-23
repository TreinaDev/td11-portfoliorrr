class Profile < ApplicationRecord
  belongs_to :user
  has_one :personal_info, dependent: :destroy

  has_many :followers, foreign_key: :followed_profile_id, dependent: :destroy,
                       inverse_of: :followed_profile
  has_many :followed_profiles, foreign_key: :follower_id, class_name: 'Follower',
                               dependent: :destroy, inverse_of: :follower
  accepts_nested_attributes_for :personal_info

  after_create :create_personal_info!
end
