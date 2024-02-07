class DeclineInvitationJob < ApplicationJob
  retry_on Faraday::ConnectionFailed, attempts: 5
  retry_on Faraday::ServerError

  def perform(invitation)
    url = "http://localhost:5000/api/v1/invitations/#{invitation.colabora_invitation_id}"
    Faraday.new { |faraday| faraday.response :raise_error }.patch(url)
    invitation.declined!
  rescue Faraday::ResourceNotFound, Faraday::ConflictError
    invitation.cancelled!
  end
end
