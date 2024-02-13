class SettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_unauthorized_access, only: %i[index]

  def index; end

  def deactivate_profile
    current_user.profile.inactive!
    sign_out current_user
    redirect_to root_path, alert: t('.success')
  end

  def delete_account
    current_user.delete_user_data
    redirect_to root_path, notice: t('.success')
  end

  def change_privacy
    @profile = current_user.profile
    if @profile.public_profile?
      @profile.private_profile!
    else
      @profile.public_profile!
    end
    redirect_to profile_settings_path(@profile), notice: t('.success')
  end

  def work_unavailable
    @profile = current_user.profile
    @profile.unavailable!
    redirect_to profile_settings_path(@profile), notice: t('.success')
  end

  def open_to_work
    @profile = current_user.profile
    @profile.open_to_work!
    redirect_to profile_settings_path(@profile), notice: t('.success')
  end

  private

  def redirect_unauthorized_access
    @profile = Profile.find(params[:profile_id])
    return if current_user == @profile.user

    redirect_to root_path, alert: t('alerts.unauthorized')
  end
end
