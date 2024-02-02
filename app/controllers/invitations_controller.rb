class InvitationsController < ApplicationController
  before_action :authenticate_user!, only: %i[index]

  def index
    @invitations = if params[:expired]
                     current_user.profile.invitations.expired
                   elsif params[:accepted]
                     current_user.profile.invitations.accepted
                   elsif params[:declined]
                     current_user.profile.invitations.declined
                   elsif params[:pending]
                     current_user.profile.invitations.pending
                   else
                     current_user.profile.invitations.order(created_at: :desc)
                   end
  end
end
