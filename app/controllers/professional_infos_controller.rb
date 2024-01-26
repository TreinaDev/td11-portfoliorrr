class ProfessionalInfosController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error
  before_action :authenticate_user!
  before_action :set_professional_info, only: %i[edit update]

  def new
    @professional_info = current_user.professional_infos.build
  end

  def create
    @professional_info = current_user.profile.professional_infos.build(professional_info_params)

    if @professional_info.save
      redirect_to user_profile_path, notice: t('.success')
    else
      flash.now[:alert] = t('.error')
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @professional_info.update(professional_info_params)
      redirect_to user_profile_path, notice: t('.success')
    else
      flash.now[:alert] = t('.error')
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_professional_info
    @professional_info = current_user.professional_infos.find(params[:id])
  end

  def professional_info_params
    params.require(:professional_info).permit(:company, :current_job, :position, :description,
                                              :start_date, :end_date, :visibility)
  end
end
