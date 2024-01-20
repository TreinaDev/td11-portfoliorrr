class PostsController < ApplicationController
  before_action :authenticate_user!, only: %w[new create edit]
  before_action :set_user, only: %w[index new create]
  before_action :set_post, only: %w[show edit update]
  before_action :ensure_user_is_author, only: %w[new create]
  before_action :redirect_invalid_edit, only: %w[edit]

  def index; end

  def new
    @post = @user.posts.build
  end

  def create
    @post = @user.posts.build(post_params)

    if @post.save
      redirect_to post_path(@post), notice: t('.success')
    else
      flash.now[:notice] = t('.error')
      render 'new', status: :unprocessable_entity
    end
  end

  def show; end

  def edit; end

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

  def ensure_user_is_author
    redirect_to root_path, alert: t('.redirect_alert.invalid_user') unless @user == current_user
  end

  def redirect_invalid_edit
    redirect_to root_path, notice: t('.redirect_alert.invalid_user') if @post.user != current_user
  end
end
