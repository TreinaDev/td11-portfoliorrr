class InvitationRequestsController < ApplicationController
  def index
    @invitation_request_infos = InvitationRequestService::InvitationRequest.send(current_user.invitation_requests)
    return @invitation_request_infos if params[:filter].blank?

    @invitation_request_infos.filter! { |request| request.status == params[:filter] }
  end
end
