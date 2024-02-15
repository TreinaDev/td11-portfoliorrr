module Api
  module V1
    class ProfilesController < ApiController
      def index
        if params[:search].blank?
          profiles = Profile.active.open_to_work.order_by_premium
          profiles = profiles.map { |profile| format_profile(profile) }
        else
          profiles = Profile.active.open_to_work.order_by_premium.get_profile_job_categories_json(params[:search])
        end
        render status: :ok, json: { data: profiles }
      end

      def show
        profile = Profile.active.find(params[:id])
        render status: :ok, json: json_output(profile)
      rescue ActiveRecord::RecordNotFound
        render status: :not_found, json: { error: I18n.t('profile_not_found') }
      end

      private

      def format_profile(profile)
        { profile_id: profile.id,
          full_name: profile.full_name,
          job_categories: profile.profile_job_categories.map do |category|
            { name: category.job_category.name, description: category.description }
          end }
      end
    end
  end
end
