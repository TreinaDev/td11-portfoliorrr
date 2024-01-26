module Api
  module V1
    class JobCategoriesController < ApiController
      def index
        job_categories = JobCategory.all
        empty_job_category_alert = 'Não há categorias de trabalho cadastradas. Contate um admin do Portfoliorrr.'

        if job_categories.empty?
          render status: :ok, json: { message: empty_job_category_alert }
        else
          render status: :ok, json: job_categories.as_json(except: %i[created_at updated_at])
        end
      end
    end
  end
end
