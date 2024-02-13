class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    like = current_user.likes.build(likeable: @likeable)
    if like.save
      redirect_to post_path(@post)
    else
      redirect_to post_path(@post), alert: t('.error')
    end
  end

  def destroy
    like = current_user.likes.find(params[:id])
    like.destroy

    redirect_to post_path(@post)
  end
end
