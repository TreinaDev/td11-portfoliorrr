module InvitationRequestService
  include ProjectsService

  COLABORA_BASE_URL = Rails.configuration.colabora_api_v1.base_url
  COLABORA_API_V1_PROJECTS_URL = Rails.configuration.colabora_api_v1.projects_url
  COLABORA_API_V1_PROPOSALS_URL = Rails.configuration.colabora_api_v1.proposals_url

  class InvitationRequest
    def self.send(requests)
      return [] if requests.empty?

      projects = ProjectsService::ColaBoraProject.send

      requests.map do |request|
        project = projects.find { |proj| proj.id == request.project_id }
        InvitationRequestInfo.new(invitation_request: request, project:)
      end
    end
  end

  class ColaBoraInvitationRequestPost
    def self.send(invitation_request)
      @invitation_request = invitation_request
      post_connection

      @response
    end

    class << self
      private

      def build_invitation_request_params(invitation_request)
        { 'proposal': { 'invitation_request_id': invitation_request.id, 'email': invitation_request.profile.email,
                        'message': invitation_request.message, 'profile_id': invitation_request.profile.id,
                        'project_id': invitation_request.project_id } }.as_json
      end

      def post_connection
        url = "#{COLABORA_BASE_URL}#{COLABORA_API_V1_PROPOSALS_URL}"
        @response = Faraday.post(url, build_invitation_request_params(@invitation_request))
      end
    end
  end
end
