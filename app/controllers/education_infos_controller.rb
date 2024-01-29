class EducationInfosController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error
  before_action :authenticate_user!
  before_action :set_education_info, only: %i[edit update]

  def new
    @education_info = current_user.education_infos.build
  end

  def create
    @education_info = current_user.profile.education_infos.build(education_info_params)

    if @education_info.save
      redirect_to profile_path(current_user.profile), notice: t('.success')
    else
      flash.now[:alert] = t('.error')
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @education_info.update(education_info_params)
      redirect_to profile_path(current_user.profile), notice: t('.success')
    else
      flash.now[:alert] = t('.error')
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_education_info
    @education_info = current_user.education_infos.find(params[:id])
  end

  def education_info_params
    params.require(:education_info).permit(:institution, :course, :start_date,
                                           :end_date, :visibility)
  end
end
