class JobCategoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @job_category = JobCategory.new
  end
end
