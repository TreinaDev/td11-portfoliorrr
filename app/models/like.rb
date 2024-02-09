class Like < ApplicationRecord
  belongs_to :user
  belongs_to :likeable, polymorphic: true
  validates :likeable_id, uniqueness: { scope: %i[user_id likeable_type] }
  has_one :notification, as: :notifiable, dependent: :destroy

  after_create :create_notification

  private

  def create_notification
    post_author = likeable.user.profile
    return if user == post_author.user

    Notification.create(profile: post_author, notifiable: self)
    
  end
end
