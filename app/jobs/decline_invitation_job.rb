class DeclineInvitationJob < ApplicationJob
  PORTFOLIORRR_BASE_URL = Rails.configuration.portfoliorrr_api_v1.base_url
  PORTFOLIORRR_INVITATION_URL = Rails.configuration.portfoliorrr_api_v1.invitations_url
  retry_on Faraday::ConnectionFailed, Faraday::ServerError, wait: :polynomially_longer, attempts: 5 do |job|
    job.arguments.first.pending!
  end

  def perform(invitation)
    url = "#{PORTFOLIORRR_BASE_URL}#{PORTFOLIORRR_INVITATION_URL}#{invitation.colabora_invitation_id}"
    Faraday.new { |faraday| faraday.response :raise_error }.patch(url)
    invitation.declined!
  rescue Faraday::ResourceNotFound, Faraday::ConflictError
    invitation.cancelled!
  end
end
