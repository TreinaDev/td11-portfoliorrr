class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    likeable, post_id = find_likeable_and_post_id
    return unless likeable

    like = current_user.likes.build(likeable:)
    if like.save
      LikesMailer.with(like:).notify_like.deliver if like.likeable_type == 'Post'
      redirect_to post_path(post_id)
    else
      redirect_to post_path(post_id), alert: t('.error')
    end
  end

  def destroy
    if params[:post_like_id]
      like = Like.find(params[:post_like_id])
      post_id = like.likeable
    elsif params[:comment_like_id]
      like = Like.find(params[:comment_like_id])
      post_id = like.likeable.post
    end

    like.destroy

    redirect_to post_path(post_id)
  end

  private

  def find_likeable_and_post_id
    if params[:post_id]
      likeable = Post.find(params[:post_id])
      [likeable, likeable.id]
    elsif params[:comment_id]
      likeable = Comment.find(params[:comment_id])
      [likeable, likeable.post_id]
    end
  end
end
