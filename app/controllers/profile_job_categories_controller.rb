class ProfileJobCategoriesController < ApplicationController
  def new
    @profile_job_category = current_user.profile.profile_job_categories.build
  end

  def create
    @profile_job_category = current_user.profile.profile_job_categories.build(profile_job_category_params)
    @profile_job_category.save!
    redirect_to user_profile_path, notice: 'Categoria de trabalho adicionada com sucesso!'
  end

  private

  def profile_job_category_params
    params.require(:profile_job_category).permit(:job_category_id, :description)
  end
end
