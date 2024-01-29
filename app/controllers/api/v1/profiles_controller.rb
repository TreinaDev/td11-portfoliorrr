module Api
  module V1
    class ProfilesController < ApiController
      def search
        profiles = Profile.get_profile_job_categories_json(params[:search])
        render status: :ok, json: profiles.as_json
      end
    end
  end
end
