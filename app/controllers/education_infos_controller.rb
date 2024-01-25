class EducationInfosController < ApplicationController
  before_action :authenticate_user!

  def new
    @education_info = current_user.education_infos.build
  end

  def create
    @education_info = current_user.profile.education_infos.build(education_info_params)

    if @education_info.save
      redirect_to user_profile_path, notice: t('.success')
    else
      flash.now[:alert] = t('.error')
      render :new, status: :unprocessable_entity
    end
  end

  private

  def education_info_params
    params.require(:education_info).permit(:institution, :course, :start_date,
                                           :end_date, :visibility)
  end
end
