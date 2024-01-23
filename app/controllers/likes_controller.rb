class LikesController < ApplicationController
  def create
    current_user.likes.create(post_id: params[:post_id])

    redirect_to post_path(params[:post_id]), notice: t('.success')
  end

  def destroy
    like = Like.find(params[:id])
    post_id_ = like.post_id
    like.destroy
    redirect_to post_path(post_id_)
  end
end
