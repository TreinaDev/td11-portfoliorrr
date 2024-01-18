class ProfilesController < ApplicationController
  before_action :authenticate_user!, only: %w[search]

  def search; end
end
