class ProfileController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile, only: %i[show]

  def show; end

  private

  def set_profile
    @profile = current_user.profile
  end
end
