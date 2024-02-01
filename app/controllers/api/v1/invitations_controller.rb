module Api
  module V1
    class InvitationsController < ApiController
      def create
        invitation = Invitation.create!(invite_params)
        render status: :created, json: { invitation_id: invitation.id }
      end

      private

      def invite_params
        params.require(:invitation).permit(:profile_id, :project_title,
                                           :project_description, :project_category,
                                           :colabora_invitation_id, :message,
                                           :expiration_date, :status)
      end
    end
  end
end
