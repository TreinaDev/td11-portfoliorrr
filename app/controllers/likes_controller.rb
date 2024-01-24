class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    if params[:post_id]
      likeable = Post.find(params[:post_id])
      post_id = likeable
    elsif params[:comment_id]
      likeable = Comment.find(params[:comment_id])
      post_id = likeable.post
    end

    like = current_user.likes.build(likeable: likeable)
    if like.save
      redirect_to post_path(post_id), notice:'Curtiu'
    end  
  end

  def destroy
    if params[:post_id]
      like = Like.find(params[:post_id])
      post_id = params[:post_id]
    elsif params[:comment_id]
      like = Like.find(params[:comment_id])
      post_id = like.likeable.post
    end

    like.destroy

    redirect_to post_path(post_id)
  end
end
