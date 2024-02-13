require 'rails_helper'

RSpec.describe AcceptInvitationRequestJob, type: :job do
  context '.perform' do
    it 'altera a solicitação de convite para "Aceita" caso receba um convite do Cola?Bora!' do
      user = create(:user)
      invitation_request = create(:invitation_request, profile: user.profile,
                                                       project_id: 2, status: :pending)

      invitation = build(:invitation, profile: user.profile, colabora_invitation_id: 1)

      colabora_invitation_json = [{
        invitation_id: 1,
        expiration_date: 3.days.from_now.to_date,
        project_id: 2,
        project_title: 'Meu primeiro projeto',
        message: 'Venha fazer parte'
      }].to_json

      fake_response = double('faraday_response', status: 200, body: colabora_invitation_json)
      allow(Faraday).to receive(:get).with("http://localhost:3000/api/v1/invitations?profile_id=#{user.profile.id}")
                    .and_return(fake_response)

      AcceptInvitationRequestJob.perform_now(invitation)

      expect(invitation_request.reload).to be_accepted
    end
  end
end
