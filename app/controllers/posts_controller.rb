class PostsController < ApplicationController
  before_action :authenticate_user!, only: %w[new create]
  before_action :set_user, only: %w[index new create]
  before_action :ensure_user_is_author, only: %w[new create]

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

  def show
    @post = Post.find(params[:id])
  end

  private

  def post_params
    params.require(:post).permit(:title, :content)
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def ensure_user_is_author
    redirect_to root_path, alert: t('.invalid_user') unless @user == current_user
  end
end
