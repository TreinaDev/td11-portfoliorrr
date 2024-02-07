class ConnectionsMailer < ApplicationMailer
  def notify_follow
    @notification = params[:notification]
    mail(subject: default_i18n_subject, to: @notification.profile.user.email)
  end
end
