class NotificationsMailer < ApplicationMailer
  def notify_like
    @notification = params[:notification]
    mail(subject: default_i18n_subject, to: @notification.profile.user.email)
  end
end
