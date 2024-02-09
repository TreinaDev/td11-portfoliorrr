class RequestInvitationJob < ApplicationJob
  queue_as :default

  def perform(invitation_request:)
    data = { data: { proposal: { invitation_request_id: invitation_request.id,
                                 project_id: invitation_request.project_id,
                                 profile_id: invitation_request.profile.id,
                                 email: invitation_request.profile.email,
                                 message: invitation_request.message } } }.as_json
    response = Faraday.new(url: 'http://localhost:4000', params: data).get('/api/v1/projects/request_invitation')
    invitation_request.process_colabora_api_response(response)
  end
end
