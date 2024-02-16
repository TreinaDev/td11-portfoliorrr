class RequestInvitationJob < ApplicationJob
  PORTFOLIORRR_BASE_URL = Rails.configuration.portfoliorrr_api_v1.base_url
  PORTFOLIORRRR_REQUEST_INVITATION_URL = Rails.configuration.portfoliorrr_api_v1.request_invitation_url
  queue_as :default
  retry_on Exceptions::PortfoliorrrAPIOffline, wait: 1.hour, attempts: :unlimited
  retry_on Exceptions::ColaBoraAPIOffline, wait: 1.hour, attempts: 5 do |job, _error|
    job.arguments.first[:invitation_request].aborted!
  end

  def perform(invitation_request:)
    data = { invitation_request_id: invitation_request.id }.as_json
    response = Faraday.new(url: PORTFOLIORRR_BASE_URL, params: data).get(PORTFOLIORRRR_REQUEST_INVITATION_URL)
    return raise Exceptions::PortfoliorrrAPIOffline if response.status == :internal_server_error

    invitation_request.process_colabora_api_response(response)
  end
end
