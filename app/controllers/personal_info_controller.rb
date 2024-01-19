class PersonalInfoController < ApplicationController
  before_action :authenticate_user!
  before_action :set_personal_info, only: %i[edit update]

  def edit; end

  def update
    @personal_info.update personal_info_params

    redirect_to user_profile_path
  end

  private

  def personal_info_params
    params.require(:personal_info).permit :street, :city, :state,
                                          :area, :phone, :zip_code,
                                          :street_number, :birth_date
  end

  def set_personal_info
    @personal_info = current_user.profile.personal_info
  end
end
