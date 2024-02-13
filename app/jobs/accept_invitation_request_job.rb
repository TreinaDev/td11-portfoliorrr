class AcceptInvitationRequestJob < ApplicationJob
  queue_as :default

  retry_on Faraday::ConnectionFailed, Faraday::ServerError, wait: :polynomially_longer, attempts: 5 do
    Rails.logger.debug 'Falha na conexão com Cola?Bora!'
  end

  def perform(profile_id:, colabora_invitation_id:)
    project_id = InvitationRequestService::ProjectIdRetriever.send(profile_id:, colabora_invitation_id:)

    request = InvitationRequest.pending.find_by(profile_id:, project_id:)
    request.accepted! if request.present?
  end
end
