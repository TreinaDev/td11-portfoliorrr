module Api
  module V1
    class ProfilesController < ApiController
      def search
        profiles = Profile.search_by_job_categories(params[:search])
        render status: :ok, json: profiles.as_json(except: %i[created_at updated_at])
      end
    end
  end
end
