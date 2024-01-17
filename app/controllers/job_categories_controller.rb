class JobCategoriesController < ApplicationController
  before_action :authenticate_user!, :user_admin?

  def index
    @job_category = JobCategory.new
    @job_categories = JobCategory.all
  end

  def create
    job_category_params = params.require(:job_category).permit(:name)
    @job_category = JobCategory.new(job_category_params)
    if @job_category.save
      redirect_to job_categories_path, notice: t('notices.job_category_created')
    else
      render :index
    end
  end

  private

  def user_admin?
    return if current_user.admin?

    redirect_to root_path, alert: t('alerts.unauthorized')
  end
end
