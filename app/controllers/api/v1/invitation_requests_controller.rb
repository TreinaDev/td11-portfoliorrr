module Api
  module V1
    class InvitationRequestsController < ApiController
      def update
        invitation_request = InvitationRequest.find(params[:id])
        invitation_request.refused!
        render status: :ok, json: invitation_request.as_json(except: %i[created_at updated_at])
      end
    end
  end
end
