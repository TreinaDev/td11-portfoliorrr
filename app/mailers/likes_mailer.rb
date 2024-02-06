class LikesMailer < ApplicationMailer
  default from: 'no-reply@portfoliorrr.com'

  def notify_like
    @like = params[:like]

    notify_post_like if @like.likeable.is_a?(Post)
    notify_comment_like if @like.likeable.is_a?(Comment)
  end

  private

  def notify_post_like
    mail(subject: "Curtiram sua publicação #{@like.likeable.title}", to: @like.likeable.user.email)
  end

  def notify_comment_like
    mail(subject: "Curtiram seu comentário na publicação #{@like.likeable.post.title}", to: @like.likeable.user.email)
  end
end
