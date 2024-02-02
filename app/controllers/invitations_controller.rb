class InvitationsController < ApplicationController
  def index
    @invitations = current_user.profile.invitations
  end
end
