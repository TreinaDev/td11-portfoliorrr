class LikesMailer < ApplicationMailer
  default from: 'no-reply@portfoliorrr.com'

  def notify_like
    @like = params[:like]

    mail(subject: "Curtiram sua publicação #{@like.likeable.title}", to: @like.likeable.user.email)
  end
end
