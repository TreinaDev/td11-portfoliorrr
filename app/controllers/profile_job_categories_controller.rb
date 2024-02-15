class ProfileJobCategoriesController < ApplicationController
  before_action :authenticate_user!, only: %w[new create edit destroy update]
  before_action :check_if_job_categories_exist, only: %w[new create]
  before_action :set_profile_job_category, only: %w[edit destroy update]
  before_action :authorize, only: %w[edit destroy update]

  def new
    @profile_job_category = current_user.profile.profile_job_categories.build
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

  def edit; end

  def destroy
    @profile_job_category.destroy!
    redirect_to current_user.profile, notice: t('.success')
  end

  def update
    @profile_job_category.update! profile_job_category_params
    redirect_to current_user.profile, notice: t('.success')
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

  def set_profile_job_category
    @profile_job_category = ProfileJobCategory.find params[:id]
  end

  def authorize
    return if current_user.profile == @profile_job_category.profile

    redirect_to current_user.profile, alert: t('alerts.unauthorized')
  end
end
