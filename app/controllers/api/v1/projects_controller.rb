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
        invitation_request_id = proposal_params.fetch('invitation_request_id').to_i
        invitation_request = InvitationRequest.find(invitation_request_id)
        response = InvitationRequestService::ColaBoraInvitationRequestPost.send(invitation_request)

        if response.status == 201
          proposal = JSON.parse(response.body)
          render status: :ok, json: proposal.as_json
        else
          errors = response.body
          render status: :ok, json: errors.as_json
        end
      end

      private

      def proposal_params
        params.permit(:invitation_request_id)
      end
    end
  end
end
