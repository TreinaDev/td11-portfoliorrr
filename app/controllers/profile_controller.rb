class ProfileController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile, only: %i[edit update show]

  def edit
    @profile.professional_infos.build if @profile.professional_infos.empty?
  end

  def update
    redirect_to user_profile_path if @profile.update(profile_params)
  end

  def show; end

  private

  def profile_params
    personal_info_attributes = %i[street city state
                                  area phone zip_code visibility
                                  street_number birth_date]
    professional_infos_attributes = %i[id company position
                                       start_date end_date visibility]
    params.require(:profile).permit :cover_letter, personal_info_attributes:,
                                                   professional_infos_attributes:
  end

  def set_profile
    @profile = current_user.profile
  end
end
