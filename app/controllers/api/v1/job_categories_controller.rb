module Api
  module V1
    class JobCategoriesController < ApiController
      def index
        job_categories = JobCategory.all

        if job_categories.empty?
          render status: :ok, json: []
        else
          render status: :ok, json: job_categories.as_json(except: %i[created_at updated_at])
        end
      end
    end
  end
end
