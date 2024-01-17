class JobCategoriesController < ApplicationController
  def index
    @job_category = JobCategory.new
  end
end
