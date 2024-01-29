class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @profile = Profile.find(params[:id])
    @user = @profile.user
    @followers_count = @profile.followers_count
    @followed_count = @profile.followed_count
    @professional_infos = @profile.professional_infos.order(start_date: :desc)

    @personal_info = if current_user == @user
                       @profile.personal_info.non_date_attributes
                     else
                       @profile.personal_info.non_empty_attributes
                     end
  end

  def search
    @query = params[:query]

    return redirect_back(fallback_location: root_path, alert: t('.error')) if @query.blank?

    @profiles = Profile.advanced_search(@query)
  end
end
