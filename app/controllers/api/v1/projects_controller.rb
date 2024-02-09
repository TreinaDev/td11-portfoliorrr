module Api
  module V1
    class ProjectsController < ApiController
      def index
        response = Faraday.get('http://localhost:3000/api/v1/projects')
        if response.status == 200
          projects = JSON.parse(response.body)
          render status: :ok, json: projects.as_json
        elsif response.status == 500
          errors = JSON.parse(response.body)
          render status: :internal_server_error, json: errors.as_json
        end
      end

      def request_invitation
        data = proposal_params.as_json
        connection = Faraday.new(url: 'http://localhost:3000', params: data)
        response = connection.post('api/v1/proposals')

        return unless response.status == 201

        proposal = JSON.parse(response.body)
        render status: :ok, json: proposal.as_json
      end

      private

      def proposal_params
        proposal_attributes = %i[invitation_request_id email message profile_id project_id]
        params.require(:data).permit(proposal: proposal_attributes)
      end
    end
  end
end
