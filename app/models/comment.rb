class Comment < ApplicationRecord
  validates :message, presence: true
  belongs_to :post
  belongs_to :user
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :reports, as: :reportable, dependent: :destroy
  has_many :notification, as: :notifiable, dependent: :destroy

  after_create :notify_interested_users

  private

  def notify_interested_users
    PostInterestNotificationJob.perform_later(self)
  end
end
