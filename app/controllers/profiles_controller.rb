class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile_by_id, only: %i[show edit remove_photo update]
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
    @profile.set_default_photo
    redirect_to profile_path(@profile), notice: t('.success')
  end

  def show
    @user = @profile.user
    @followers_count = @profile.followers_count
    @followed_count = @profile.followed_count
    @professional_infos = @profile.professional_infos.order(start_date: :desc)

    @personal_info = if current_user == @user
                       @profile.personal_info.non_date_attributes
                     else
                       @profile.personal_info.non_empty_attributes
                     end
  end

  def search
    @query = params[:query]

    return redirect_back(fallback_location: root_path, alert: t('.error')) if @query.blank?

    @profiles = Profile.advanced_search(@query)
  end

  private

  def set_profile_by_id
    @profile = Profile.find(params[:id])
  end

  def profile_params
    params.require(:profile).permit(:photo)
  end

  def redirect_unauthorized_access
    return if current_user == @profile.user

    redirect_to root_path, alert: t('.redirect_alert.unauthorized_user')
  end
end
