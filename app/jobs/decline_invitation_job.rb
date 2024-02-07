class DeclineInvitationJob < ApplicationJob
  retry_on Faraday::ConnectionFailed, Faraday::ServerError, wait: :polynomially_longer, attempts: 5 do |job|
    job.arguments.first.pending!
  end

  def perform(invitation)
    url = "http://localhost:4000/api/v1/invitations/#{invitation.colabora_invitation_id}"
    Faraday.new { |faraday| faraday.response :raise_error }.patch(url)
    invitation.declined!
  rescue Faraday::ResourceNotFound, Faraday::ConflictError
    invitation.cancelled!
  end
end
