module Api
  module V1
    class ProfilesController < ApiController
      def search
        if params[:search].blank?
          render status: :bad_request, json: { error: 'É necessário fornecer um parâmetro de busca' }
        else
          profiles = Profile.get_profile_job_categories_json(params[:search])
          render status: :ok, json: profiles.as_json
        end
      end
    end
  end
end
