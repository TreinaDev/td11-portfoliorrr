module Api
  module V1
    class JobCategoriesController < ApiController
      def index
        job_categories = JobCategory.all

        if job_categories.empty?
          render status: :ok, json: { data: [] }
        else
          job_categories = job_categories.as_json(except: %i[created_at updated_at])
          render status: :ok, json: { data: job_categories }
        end
      end

      def show
        job_category = JobCategory.find(params[:id])

        render status: :ok, json: { data: job_category.as_json(except: %i[created_at updated_at]) }
      end
    end
  end
end
