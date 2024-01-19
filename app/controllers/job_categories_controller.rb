class JobCategoriesController < ApplicationController
  before_action :authenticate_user!, :authorize!

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
      @job_categories = JobCategory.all
      flash.now[:alert] = t('alerts.job_category_fail')
      render 'index', status: :internal_server_error
    end
  end

  private

  def authorize!
    return if current_user.admin?

    redirect_to root_path, alert: t('alerts.unauthorized')
  end
end
