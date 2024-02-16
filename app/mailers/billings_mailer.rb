class BillingsMailer < ApplicationMailer
  default from: 'billing@portfoliorrr.com'

  def notify_billing
    @billing = params[:billing]
    @user = @billing.subscription.user

    mail(subject: default_i18n_subject, to: @user.email)
  end
end
