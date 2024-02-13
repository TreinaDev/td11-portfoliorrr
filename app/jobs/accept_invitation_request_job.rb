class AcceptInvitationRequestJob < ApplicationJob
  queue_as :default

  def perform(invitation)
    project_id = InvitationRequestService::ProjectIdRetriever.send(invitation)

    request = InvitationRequest.pending.find_by(profile_id: invitation.profile.id, project_id:)
    request.accepted! if request.present?
  end
end
