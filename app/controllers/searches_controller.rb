class SearchesController < ApplicationController
  before_action :authenticate_user!

  def index
    @query = params[:query].strip

    if @query.starts_with?('#')
      @tags = @query.split('#')
      @tags.shift
      @posts = Post.tagged_with(@tags, any: true)
    else
      @query = params[:query]

      return redirect_back(fallback_location: root_path, alert: t('profiles.search.error')) if @query.blank?

      @profiles = Profile.advanced_search(@query)
    end
  end
end
