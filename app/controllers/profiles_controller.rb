class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile_and_posts, only: %i[show]

  def show
    @professional_infos = @profile.professional_infos.order(start_date: :desc)
    @personal_info = personal_info
  end

  def work_unavailable
    @profile = current_user.profile
    @profile.unavailable!
    redirect_to profile_path(@profile), notice: t('.success')
  end

  def open_to_work
    @profile = current_user.profile
    @profile.open_to_work!
    redirect_to profile_path(@profile), notice: t('.success')
  end

  private

  def set_profile_and_posts
    @profile = Profile.find(params[:id])
    @posts = current_user == @profile.user ? @profile.posts : @profile.posts.published
  end

  def personal_info
    if current_user == @profile.user
      @profile.personal_info.non_date_attributes
    else
      @profile.personal_info.non_empty_attributes
    end
  end
end
