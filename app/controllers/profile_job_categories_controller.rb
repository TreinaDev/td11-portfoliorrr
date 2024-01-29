class ProfileJobCategoriesController < ApplicationController
  before_action :authenticate_user!, only: %w[new create]
  before_action :check_if_job_categories_exist, only: %w[new create]

  def new
    @profile_job_category = current_user.profile.profile_job_categories.build
    flash.now[:notice] = t('.inform_user_edit_is_unavailable')
  end

  def create
    @profile_job_category = current_user.profile.profile_job_categories.build(profile_job_category_params)

    if @profile_job_category.save
      redirect_to profile_path(@profile_job_category.profile), notice: t('.success')
    else
      flash.now[:alert] = t('.error')
      render :new, status: :unprocessable_entity
    end
  end

  private

  def profile_job_category_params
    params.require(:profile_job_category).permit(:job_category_id, :description)
  end

  def check_if_job_categories_exist
    return unless JobCategory.none?

    redirect_to profile_path(current_user.profile),
                notice: t('.check_if_job_categories_exist.error')
  end
end
