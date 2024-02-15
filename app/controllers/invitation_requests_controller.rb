class InvitationRequestsController < ApplicationController
  before_action :authenticate_user!, only: %i[index]

  def index
    invitation_requests = current_user.invitation_requests
    @error = false
    @invitation_request_infos = []

    begin
      @invitation_request_infos = InvitationRequestService::InvitationRequest.send(invitation_requests)
    rescue StandardError
      return @error = true
    end

    return @invitation_request_infos if params[:filter].blank?

    @invitation_request_infos.filter! { |request| request.status == params[:filter] }
  end
end
