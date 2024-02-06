class Like < ApplicationRecord
  belongs_to :user
  belongs_to :likeable, polymorphic: true

  after_create :send_like_notification_mail

  validates :likeable_id, uniqueness: { scope: %i[user_id likeable_type] }

  private

  def send_like_notification_mail
    LikesMailer.with(like: self).notify_like.deliver
  end
end
