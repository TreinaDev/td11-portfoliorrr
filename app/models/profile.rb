class Profile < ApplicationRecord
  belongs_to :user
  has_one :personal_info, dependent: :destroy
  has_many :professional_infos, dependent: :destroy
  has_many :education_infos, dependent: :destroy

  has_many :followers, class_name: 'Connection', foreign_key: :followed_profile_id, dependent: :destroy,
                       inverse_of: :follower

  has_many :followed_profiles, class_name: 'Connection', foreign_key: :follower_id,
                               dependent: :destroy, inverse_of: :followed_profile

  has_many :connections, foreign_key: :followed_profile_id, dependent: :destroy, inverse_of: :followed_profile

  accepts_nested_attributes_for :personal_info
  accepts_nested_attributes_for :professional_infos
  accepts_nested_attributes_for :education_infos

  after_create :create_personal_info!

  delegate :full_name, to: :user

  def followers_count
    followers.active.count
  end

  def followed_count
    followed_profiles.active.count
  end

  def following?(profile)
    followers.active.where(follower: profile).any?
  end

  def inactive_follower?(profile)
    followers.inactive.where(follower: profile).any?
  end
end
