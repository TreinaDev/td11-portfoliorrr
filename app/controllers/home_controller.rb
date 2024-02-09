class HomeController < ApplicationController
  def index
    return unless current_user

    followed_users_id = Connection.where(follower: current_user.profile).active.pluck(:followed_profile_id)
    @followed_posts = Post.where(user_id: followed_users_id).published.order(created_at: :desc)
    @most_followed = Profile.active.most_followed(3)

    return if @followed_posts.any?

    @posts = Post.get_sample(3)
  end
end
