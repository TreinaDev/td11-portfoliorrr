class SearchesController < ApplicationController
  before_action :authenticate_user!

  def index
    redirect_back(fallback_location: root_path, alert: t('.error')) if params[:query].blank?

    @query = params[:query].strip

    return search_posts if @query.starts_with?('#')

    search_profiles
  end

  private

  def search_posts
    @tags = @query.split('#')
    @tags.shift
    @posts = Post.tagged_with(@tags, any: true)
  end

  def search_profiles
    @query = params[:query]
    @profiles = Profile.advanced_search(@query)
  end
end
