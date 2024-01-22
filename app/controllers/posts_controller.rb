class PostsController < ApplicationController
  before_action :authenticate_user!, only: %w[new create edit]
  before_action :set_user, only: %w[index]
  before_action :set_post, only: %w[show edit update]

  def index; end

  def new
    @user = current_user
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to post_path(@post), notice: t('.success')
    else
      flash.now[:notice] = t('.error')
      render 'new', status: :unprocessable_entity
    end
  end

  def show; end

  def edit
    redirect_to root_path, notice: t('.redirect_alert.invalid_user') if @post.user != current_user
  end

  def update
    if @post.update(post_params)
      redirect_to post_path(@post), notice: t('.success')
    else
      flash.now[:notice] = t('.error')
      render 'edit', status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :content)
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
