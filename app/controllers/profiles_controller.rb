class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile_and_posts, only: %i[show edit remove_photo update]
  before_action :private_profile?, only: %i[show]
  before_action :redirect_unauthorized_access, only: %i[edit update remove_photo]

  def edit; end

  def update
    if @profile.update(profile_params)
      redirect_to profile_path(@profile), notice: t('.success')
    else
      flash.now[:alert] = t('.error')
      render 'edit', status: :unprocessable_entity
    end
  end

  def remove_photo
    @profile.photo.destroy!
    redirect_to profile_path(@profile), notice: t('.success')
  end

  def show
    @user = @profile.user
    @followers_count = @profile.followers_count
    @followed_count = @profile.followed_count
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

  def change_privacy
    @profile = current_user.profile
    if @profile.public_profile?
      @profile.private_profile!
    else
      @profile.public_profile!
    end
    redirect_to profile_path(@profile), notice: t('.success')
  end

  def private_profile?
    return if @profile.user == current_user
    return if Connection.active.where(followed_profile: @profile,
                                      follower: current_user.profile).present?
    return if @profile.public_profile?

    redirect_to root_path, alert: t('.private')
  end

  private

  def profile_params
    params.require(:profile).permit(:photo)
  end

  def redirect_unauthorized_access
    return if current_user == @profile.user

    redirect_to root_path, alert: t('alerts.unauthorized')
  end

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
