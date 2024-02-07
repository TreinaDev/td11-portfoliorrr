class DeclineInvitationJob < ApplicationJob
  retry_on Faraday::ConnectionFailed

  def perform(invitation)
    invitation.update status: DeclineInvitationService.send_decline(invitation.colabora_invitation_id)
  end
end
