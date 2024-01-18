class ProfilesController < ApplicationController
  before_action :authenticate_user!, only: %w[search]

  def search
    query = params[:query]

    return redirect_back(fallback_location: root_path, alert: t('.error')) if query.blank?

    @users = User.search_by_full_name(query)
  end
end
