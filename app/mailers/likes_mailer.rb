class LikesMailer < ApplicationMailer
  default from: 'no-reply@portfoliorrr.com'

  def notify_like
    @user = params[:user]
    fetch_likes_from_posts_and_comments
    fetch_most_liked_post_and_comment
    mail(subject: "Você recebeu #{@post_likes.count + @comment_likes.count} curtidas nas últimas 24 horas!",
         to: @user.email)
  end

  private

  def fetch_likes_from_posts_and_comments
    @post_likes = @user.posts.map(&:likes).flatten
    @comment_likes = @user.comments.map(&:likes).flatten
  end

  def fetch_most_liked_post_and_comment
    @most_liked_post = @user.posts.sort_by { |post| post.likes.count }.reverse.first
    @most_liked_comment = @user.comments.sort_by { |comment| comment.likes.count }.reverse.first
  end
end
