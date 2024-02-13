module InvitationRequestService
  COLABORA_PROJECTS_URL = 'http://localhost:3000/api/v1/projects'.freeze
  COLABORA_INVITATIONS_BASE_URL = 'http://localhost:3000/api/v1/invitations'.freeze

  class ColaboraProject
    def self.send
      @response = Faraday.get(COLABORA_PROJECTS_URL)
      return build_projects if @response.success?

      raise StandardError
    end

    class << self
      private

      def build_projects
        projects = JSON.parse(@response.body, symbolize_names: true)
        projects.map do |project|
          Project.new(id: project[:id],
                      title: project[:title],
                      description: project[:description],
                      category: project[:category])
        end
      end
    end
  end

  class InvitationRequest
    def self.send(requests)
      return [] if requests.empty?

      projects = ColaboraProject.send

      requests.map do |request|
        project = projects.find { |proj| proj.id == request.project_id }
        InvitationRequestInfo.new(invitation_request: request, project:)
      end
    end
  end

  class ProjectIdRetriever
    def self.send(invitation)
      response = Faraday.get("#{COLABORA_INVITATIONS_BASE_URL}?profile_id=#{invitation.profile_id}")
      response_json = JSON.parse(response.body, symbolize_names: true)

      invitation = response_json.find do |inv|
        inv[:invitation_id] == invitation.colabora_invitation_id
      end
      invitation[:project_id]
    end
  end
end
