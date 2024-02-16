class PostsController < ApplicationController
  before_action :authenticate_user!, only: %w[new create edit pin]
  before_action :set_post, only: %w[show edit update pin publish]
  before_action :authorize!, only: %w[edit update pin]
  before_action :blocks_update, only: %w[update]
  before_action :redirect_if_removed_content, only: %w[show edit update pin]

  require 'image_processing/mini_magick'

  def new
    @user = current_user
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to post_path(@post), notice: t('.success', status: t("post_creation.#{@post.status}"))
    else
      flash.now[:notice] = t('.error')
      render 'new', status: :unprocessable_entity
    end
  end

  def show
    authorize! unless @post.published?

    @comment = Comment.new
    @likes_count = @post.likes.count
    @liked = Like.find_by(user: current_user, likeable: @post)
    @reply = Reply.new
  end

  def edit; end

  def update
    if @post.update(post_params)
      redirect_to post_path(@post), notice: t('.success')
    else
      flash.now[:notice] = t('.error')
      render 'edit', status: :unprocessable_entity
    end
  end

  def pin
    if @post.unpinned?
      @post.pinned!
      redirect_to profile_path(current_user.profile.slug), notice: t('.pinned.success')
    else
      @post.unpinned!
      redirect_to profile_path(current_user.profile.slug), notice: t('.unpinned.success')
    end
  end

  def publish
    @post.published!
    redirect_to post_path(@post), notice: t('.success')
  end

  private

  def post_params
    post_params = params.require(:post).permit(:title, :content, :tag_list, :status, :published_at)
    post_params['edited_at'] = Time.zone.now
    post_params['published_at'] = Time.zone.now if params['status'] == 'published'
    post_params
  end

  def set_post
    @post = Post.friendly.find(params[:id])
  end

  def authorize!
    redirect_to root_path, alert: t('.redirect_alert.invalid_user') unless @post.user == current_user
  end

  def blocks_update
    redirect_to root_path, alert: t('.error') if @post.published? && @post.published_at && post_params['published_at']
  end

  def redirect_if_removed_content
    return if current_user&.admin?

    redirect_to root_path, alert: t('.redirect_alert.invalid_user') if @post.removed?
  end
end
