class Profile < ApplicationRecord
  belongs_to :user
  has_one :personal_info, dependent: :destroy

  has_many :followers, foreign_key: :followed_profile_id, dependent: :destroy,
                       inverse_of: :followed_profile
  has_many :followed_profiles, foreign_key: :follower_id, class_name: 'Follower',
                               dependent: :destroy, inverse_of: :follower
  accepts_nested_attributes_for :personal_info

  after_create :create_personal_info!

  delegate :full_name, to: :user

  def find_followed_profile(followed_profile)
    followed_profiles.find_by(followed_profile:)
  end

  def followers_count
    followers.active.where(followed_profile: self).count
  end

  def followed_count
    followed_profiles.active.where(follower: self).count
  end

  def following?(profile)
    followers.active.where(follower: profile).any?
  end

  def inactive_follower?(profile)
    followers.inactive.where(follower: profile).any?
  end
end
