module Api
  module V1
    class InvitationsController < ApiController
      def create
        invitation = Invitation.create!(invite_params)
        render status: :created, json: { data: { invitation_id: invitation.id } }
      end

      def update
        status = params.permit(:status)[:status]
        return render status: :bad_request, json: { error: 'Status inválido' } unless Invitation.statuses.key? status

        invitation = Invitation.find(params[:id])
        invitation.update!(status:)
      end

      private

      def invite_params
        invitation_params = :profile_id, :project_title,
                            :project_description, :project_category,
                            :colabora_invitation_id, :message,
                            :expiration_date, :status
        params.require(:invitation).permit(invitation_params)
      end
    end
  end
end