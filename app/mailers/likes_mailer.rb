class LikesMailer < ApplicationMailer
  default from: 'no-reply@portfoliorrr.com'

  def notify_like
    @user = params[:user]
    @post_likes = @user.received_post_likes_since(1)
    @comment_likes = @user.received_comment_likes_since(1)
    @most_liked_post = @user.most_liked_post_since(1)
    @most_liked_comment = @user.most_liked_comment_since(1)

    mail(subject: t('.subject', likes: @post_likes.count + @comment_likes.count),
         to: @user.email)
  end
end
