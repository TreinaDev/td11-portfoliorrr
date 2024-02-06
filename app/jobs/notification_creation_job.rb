class NotificationCreationJob < ApplicationJob
  queue_as :default

  def perform(user, notifiable)
    Notification.create(user:, notifiable:)
  end
end
