class FollowersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile, only: %i[following index]

  def create
    followed_profile = Profile.find params[:profile_id]
    new_follow = followed_profile.followers.build(follower: current_user.profile)

    if new_follow.save
      redirect_to profile_path(followed_profile), notice: t('.success', full_name: followed_profile.full_name)
    else
      redirect_to profile_path(followed_profile), alert: t('.error')
    end
  end

  def following
    @followed_profiles = @profile.followed_profiles.active.where(follower: @profile)
  end

  def index
    @follower_profiles = @profile.followers.active.where(followed_profile: @profile)
  end

  def update
    follow_relationship = Follower.find params[:id]
    followed_profile = follow_relationship.followed_profile
    if follow_relationship.active?
      follow_relationship.inactive!
      redirect_to profile_path(followed_profile), notice: t('.inactivate', full_name: followed_profile.full_name)
    else
      follow_relationship.active!
      redirect_to profile_path(followed_profile), notice: t('.activate', full_name: followed_profile.full_name)
    end
  end

  private

  def set_profile
    @profile = Profile.find params[:profile_id]
  end
end
