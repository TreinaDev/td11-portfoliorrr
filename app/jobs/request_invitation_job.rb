class RequestInvitationJob < ApplicationJob
  queue_as :default
  retry_on Exceptions::PortfoliorrrAPIOffline, wait: 1.hour, attempts: :unlimited
  retry_on Exceptions::ColaBoraAPIOffline, wait: 1.hour, attempts: 5 do |job, _error|
    job.arguments.first[:invitation_request].aborted!
  end

  def perform(invitation_request:)
    data = { invitation_request_id: invitation_request.id }.as_json
    response = Faraday.new(url: 'http://localhost:4000', params: data).get('/api/v1/projects/request_invitation')
    return raise Exceptions::PortfoliorrrAPIOffline if response.status == :internal_server_error

    invitation_request.process_colabora_api_response(response)
  end
end
