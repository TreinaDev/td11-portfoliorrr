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
      allow(Faraday).to receive_message_chain(:new, :get).with("http://localhost:3000/api/v1/invitations?profile_id=#{user.profile.id}")
                    .and_return(fake_response)

      AcceptInvitationRequestJob.perform_now(
        profile_id: user.profile.id,
        colabora_invitation_id: invitation.colabora_invitation_id
      )

      expect(invitation_request.reload).to be_accepted
    end

    it 'tenta alterar o status para "Aceita" e não consegue se conectar ao servidor' do
      allow(Faraday).to receive_message_chain(:new, :get).and_raise(Faraday::ConnectionFailed)

      user = create(:user)
      invitation_request = create(:invitation_request, status: :pending)
      invitation = build(:invitation, profile: user.profile, colabora_invitation_id: 1)

      AcceptInvitationRequestJob.perform_now(
        profile_id: user.profile.id,
        colabora_invitation_id: invitation.colabora_invitation_id
      )

      expect(invitation_request.reload.status).to eq 'pending'
    end

    it 'tenta alterar o status para "aceita" 5 vezes' do
      allow(Faraday).to receive_message_chain(:new, :get).and_raise(Faraday::ConnectionFailed)

      user = create(:user)
      invitation_request = create(:invitation_request, status: :pending)
      invitation = build(:invitation, profile: user.profile, colabora_invitation_id: 1)

      perform_enqueued_jobs do
        AcceptInvitationRequestJob.perform_later(
          profile_id: user.profile.id,
          colabora_invitation_id: invitation.colabora_invitation_id
        )
      end

      assert_performed_jobs 5
      expect(invitation_request).to be_pending
    end
  end
end
