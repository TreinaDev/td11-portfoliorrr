class ProfileJobCategoriesController < ApplicationController
  before_action :authenticate_user!, only: %w[new create]

  def new
    @profile_job_category = current_user.profile.profile_job_categories.build
  end

  def create
    @profile_job_category = current_user.profile.profile_job_categories.build(profile_job_category_params)

    if @profile_job_category.save
      redirect_to user_profile_path, notice: t('.success')
    else
      flash.now[:alert] = t('.error')
      render :new, status: :unprocessable_entity
    end
  end

  private

  def profile_job_category_params
    params.require(:profile_job_category).permit(:job_category_id, :description)
  end
end
