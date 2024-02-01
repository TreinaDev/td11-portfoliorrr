module Api
  module V1
    class InvitationsController < ApiController
      def create
        invitation = Invitation.create!(invite_params[:invitation])
        render status: :created, json: { invitation_id: invitation.id }
      end

      def update
        invitation_params = params.require(:data).permit(:status)
        unless Invitation.statuses.key? invitation_params[:status]
          return render status: :bad_request, json: { error: 'Status inválido' }
        end

        invitation = Invitation.find(params[:id])
        invitation.update!(invitation_params)
      end

      private

      def invite_params
        invitation_params = :profile_id, :project_title,
                            :project_description, :project_category,
                            :colabora_invitation_id, :message,
                            :expiration_date, :status
        params.require(:data).permit(invitation: invitation_params)
      end
    end
  end
end
