module Api
  module V1
    class ProfilesController < ApiController
      def index
        if params[:search].blank?
          profiles = Profile.active.open_to_work
          profiles = profiles.map { |profile| format_profile(profile) }
        else
          profiles = Profile.active.open_to_work.get_profile_job_categories_json(params[:search])
        end
        render status: :ok, json: { data: profiles }
      end

      def show
        profile = Profile.active.find(params[:id])
        render status: :ok, json: json_output(profile)
      rescue ActiveRecord::RecordNotFound
        render status: :not_found, json: { error: 'Perfil não existe.' }
      end

      private

      def format_profile(profile)
        { profile_id: profile.id,
          full_name: profile.full_name,
          job_categories: profile.profile_job_categories.map do |category|
            { name: category.job_category.name, description: category.description }
          end }
      end

      def result(profile)
        { data: {
          profile_id: profile.id, email: profile.user.email,
          full_name: profile.full_name, cover_letter: profile.cover_letter,
          professional_infos: profile.professional_infos.as_json(only: %i[company position start_date end_date
                                                                          current_job description]),
          education_infos: profile.education_infos.as_json(only: %i[institution course start_date end_date]),
          job_categories: profile.profile_job_categories.map do |category|
            { name: category.job_category.name, description: category.description }
          end
        } }
      end
    end
  end
end
