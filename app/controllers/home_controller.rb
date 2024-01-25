class HomeController < ApplicationController
  def index
    return unless current_user

    @posts = Post.get_sample(3)

    followed_users_id = Connection.where(follower: current_user.profile).active.pluck(:followed_profile_id)

    @followed_posts = Post.where(user_id: followed_users_id).order(created_at: :desc)
  end
end
