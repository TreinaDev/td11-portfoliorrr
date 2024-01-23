class Follower < ApplicationRecord
  belongs_to :follower, class_name: 'Profile'
  belongs_to :followed_profile, class_name: 'Profile'

  validate :cant_follow_yourself
  validates :followed_profile, uniqueness: { scope: :follower_id }

  enum status: { inactive: 0, active: 1 }

  private

  def cant_follow_yourself
    return unless followed_profile == follower

    errors.add(:followed_profile, 'não pode ser o mesmo do usuário')
  end
end
