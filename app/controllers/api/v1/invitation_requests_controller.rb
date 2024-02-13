module Api
  module V1
    class InvitationRequestsController < ApiController
      def update
        raise ActiveRecord::ParameterMissing if params[:id].blank?

        invitation_request = InvitationRequest.find(params[:id])
        if invitation_request.pending?
          invitation_request.refused!
          render status: :ok, json: invitation_request.as_json(except: %i[created_at updated_at])
        else
          render status: :conflict, json: { errors: I18n.t('.api_not_pending_error') }
        end
      end
    end
  end
end
