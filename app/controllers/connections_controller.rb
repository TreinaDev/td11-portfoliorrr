class ConnectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile, only: %i[following index]

  def create
    followed_profile = Profile.find params[:profile_id]
    new_follow = followed_profile.connections.build(follower: current_user.profile)

    if new_follow.save
      redirect_to profile_path(followed_profile), notice: t('.success', full_name: followed_profile.full_name)
    else
      redirect_to profile_path(followed_profile), alert: t('.error')
    end
  end

  def following
    @followed_profiles = @profile.followed_profiles.active
  end

  def index
    @follower_profiles = @profile.followers.active
  end

  def update
    connection = Connection.find params[:id]
    followed_profile = connection.followed_profile
    if connection.active?
      connection.inactive!
      redirect_to profile_path(followed_profile), notice: t('.inactivate', full_name: followed_profile.full_name)
    else
      connection.active!
      redirect_to profile_path(followed_profile), notice: t('.activate', full_name: followed_profile.full_name)
    end
  end

  private

  def set_profile
    @profile = Profile.find params[:profile_id]
  end
end
