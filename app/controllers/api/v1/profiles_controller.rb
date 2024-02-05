module Api
  module V1
    class ProfilesController < ApiController
      def search
        if params[:search].blank?
          render status: :bad_request, json: { error: 'É necessário fornecer um parâmetro de busca' }
        else
          profiles = Profile.open_to_work.get_profile_job_categories_json(params[:search])
          render status: :ok, json: profiles.as_json
        end
      end

      def show
        profile = Profile.find(params[:id])
        render status: :ok, json: json_output(profile)
      rescue ActiveRecord::RecordNotFound
        render status: :not_found, json: { error: 'Perfil não existe.' }
      end

      private

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
