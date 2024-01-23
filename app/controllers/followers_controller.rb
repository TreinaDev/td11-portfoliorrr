class FollowersController < ApplicationController
  before_action :authenticate_user!

  def create
    followed_profile = Profile.find params[:profile_id]
    new_follow = followed_profile.followers.build(follower: current_user.profile)

    return unless new_follow.save

    redirect_to profile_path(followed_profile), notice: "Agora você está seguindo #{followed_profile.user.full_name}"
  end

  def update
    follow_relationship = Follower.find params[:id]
    followed_profile = follow_relationship.followed_profile
    if follow_relationship.active?
      follow_relationship.inactive!
      redirect_to profile_path(followed_profile), notice: "Você deixou de seguir #{followed_profile.user.full_name}"
    else
      follow_relationship.active!
      redirect_to profile_path(followed_profile), notice: "Agora você está seguindo #{followed_profile.user.full_name}"
    end
  end
end
