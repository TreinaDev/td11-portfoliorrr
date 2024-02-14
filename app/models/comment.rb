class Comment < ApplicationRecord
  validates :message, presence: true
  belongs_to :post
  belongs_to :user
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :reports, as: :reportable, dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy

  enum status: { published: 0, removed: 20 }

  after_create :notify_interested_users
  after_create :create_notification

  private

  def notify_interested_users
    PostInterestNotificationJob.perform_later(self)
  end

  def create_notification
    comment_author = user.profile
    return if comment_author == post.user.profile

    Notification.create(profile: post.user.profile, notifiable: self)
  end
end
