class AdvertisementsController < ApplicationController
  before_action :authenticate_user!, only: %i[index new create show]
  before_action :redirect_unauthorized_user, only: %i[index new create show]

  def index
    @advertisements = Advertisement.all
  end

  def new
    @advertisement = Advertisement.new
  end

  def create
    @advertisement = current_user.advertisements.build(ads_params)

    if @advertisement.save
      redirect_to advertisement_path(@advertisement), notice: t('.success')
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def show
    @advertisement = Advertisement.find(params[:id])
  end

  def update
    @advertisement = Advertisement.find(params[:id])
    @advertisement.update(view_count: @advertisement.view_count + 1)

    url = @advertisement.link
    url = "http://#{url}" unless url.start_with?('http://', 'https://')

    redirect_to url, allow_other_host: true
  end

  private

  def ads_params
    params.require(:advertisement).permit(:title, :link, :display_time, :image)
  end

  def redirect_unauthorized_user
    redirect_to root_path unless current_user.admin?
  end
end
