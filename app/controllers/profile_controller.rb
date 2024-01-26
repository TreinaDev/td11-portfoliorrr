class ProfileController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile, only: %i[edit update show]

  def edit
    @profile.professional_infos.build if @profile.professional_infos.empty?
    @profile.education_infos.build if @profile.education_infos.empty?
  end

  def update
    if @profile.update(profile_params)
      redirect_to profile_path(@profile), notice: t('.success')
    else
      flash.now[:alert] = t('.error')
      render :edit, status: :unprocessable_entity
    end
  end

  def show; end

  private

  def profile_params
    personal_info_attributes = %i[street city state
                                  area phone zip_code visibility
                                  street_number birth_date]

    params.require(:profile).permit :cover_letter, personal_info_attributes:
  end

  def set_profile
    @profile = current_user.profile
    @professional_infos = @profile.professional_infos.order(start_date: :desc)
  end
end
