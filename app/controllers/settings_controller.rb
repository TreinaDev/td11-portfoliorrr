class SettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_unauthorized_access, only: %i[index]

  def index; end

  def deactivate_profile
    current_user.profile.inactive!
    sign_out current_user
    redirect_to root_path, alert: t('settings.deactivate_profile')
  end

  def delete_account
    current_user.delete_user_data
    redirect_to root_path, notice: t('settings.delete_account')
  end

  private

  def redirect_unauthorized_access
    @profile = Profile.find(params[:profile_id])
    return if current_user == @profile.user

    redirect_to root_path, alert: t('alerts.unauthorized')
  end
end
