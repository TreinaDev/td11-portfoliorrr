class JobCategoriesController < ApplicationController
  before_action :authenticate_user!, :is_user_admin?

  def index
    @job_category = JobCategory.new
    @job_categories = JobCategory.all
  end

  def create
    job_category_params = params.require(:job_category).permit(:name)
    @job_category = JobCategory.new(job_category_params)
    if @job_category.save
      return redirect_to job_categories_path, notice: t('notices.job_category_created')
    end
    render :index
  end

  private

  def is_user_admin?
    unless current_user.admin?
      return redirect_to root_path, alert: t('alerts.unauthorized')
    end
  end
end
