class ConnectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile, only: %i[create following index]
  before_action :set_connection_and_profile, only: %i[unfollow follow_again]

  def create
    new_follow = @profile.connections.build(follower: current_user.profile)

    if new_follow.save
      ConnectionsMailer.with(notification: new_follow.notification).notify_follow.deliver_later
      redirect_to profile_path(@profile), notice: t('.success', full_name: @profile.full_name)
    else
      redirect_to profile_path(@profile), alert: t('.error')
    end
  end

  def following
    @followed_profiles = @profile.followed_profiles.active
  end

  def index
    @follower_profiles = @profile.followers.active
  end

  def unfollow
    if @connection.active?
      @connection.inactive!
      redirect_to profile_path(@followed_profile), notice: t('.success', full_name: @followed_profile.full_name)
    else
      redirect_to profile_path(@followed_profile), notice: t('.error')
    end
  end

  def follow_again
    if @connection.inactive?
      @connection.active!
      redirect_to profile_path(@followed_profile), notice: t('.success', full_name: @followed_profile.full_name)
    else
      redirect_to profile_path(@followed_profile), notice: t('.error')
    end
  end

  private

  def set_connection_and_profile
    @connection = Connection.find params[:connection_id]
    @followed_profile = @connection.followed_profile
  end

  def set_profile
    @profile = Profile.friendly.find params[:profile_id]
  end
end
