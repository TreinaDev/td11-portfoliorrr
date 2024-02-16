class InvitationRequestsController < ApplicationController
  before_action :authenticate_user!, only: %i[index]

  def index
    @invitation_request_infos = []
    return if current_user.subscription.inactive?

    @error = false
    request_data

    return @invitation_request_infos if params[:filter].blank?

    @invitation_request_infos.filter! { |request| request.status == params[:filter] }
  end

  private

  def request_data
    @invitation_request_infos = InvitationRequestService::InvitationRequest.send(current_user.invitation_requests)
  rescue StandardError
    @error = true
  end
end
