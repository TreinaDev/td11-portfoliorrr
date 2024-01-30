class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile_and_posts, only: %i[show]

  def show
    @professional_infos = @profile.professional_infos.order(start_date: :desc)
    @personal_info = personal_info
  end

  def search
    @query = params[:query]

    return redirect_back(fallback_location: root_path, alert: t('.error')) if @query.blank?

    @profiles = Profile.advanced_search(@query)
  end

  private

  def set_profile_and_posts
    @profile = Profile.find(params[:id])
    @posts = current_user == @profile.user ? @profile.posts : @profile.posts.published
  end

  def personal_info
    if current_user == @profile.user
      @profile.personal_info.non_date_attributes
    else
      @profile.personal_info.non_empty_attributes
    end
  end
end
