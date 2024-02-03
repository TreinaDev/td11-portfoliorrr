class InvitationsController < ApplicationController
  before_action :authenticate_user!, only: %i[index decline show]
  before_action :set_invitation, only: %i[decline show]
  before_action :authorize!, only: %i[decline show]

  def index
    status = params[:status]
    @invitations = if Invitation.statuses.key? status
                     current_user.profile.invitations.send(status)
                   else
                     current_user.profile.invitations
                   end
  end

  def decline
    if @invitation.declined?
      redirect_to invitation_path(@invitation), notice: t('.error')
    else
      @invitation.update status: 'declined'
      redirect_to invitation_path(@invitation), notice: t('.success')
    end
  end

  def show; end

  private

  def set_invitation
    @invitation = Invitation.find(params[:id])
  end

  def authorize!
    redirect_to root_path, alert: t('alerts.unauthorized') unless @invitation.profile.user == current_user
  end
end
