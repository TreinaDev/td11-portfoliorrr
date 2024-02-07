require 'rails_helper'

RSpec.describe DeclineInvitationService do
  context '.send_decline' do
    it 'verdadeiro quando efetua a requisição e mantém status recusado' do
      fake_response = double('faraday_response', status: 200, success?: true)
      allow(Faraday).to receive(:patch).and_return(fake_response)
      invitation = create(:invitation, colabora_invitation_id: 1, status: :declined)

      response = DeclineInvitationService.send_decline(invitation.colabora_invitation_id)

      expect(response).to eq true
      expect(Invitation.count).to eq 1
      expect(invitation.reload.status).to eq 'declined'
    end

    it 'falso quando acontece bad request e mantém status recusado' do
      fake_response = double('faraday_response', status: 404, success?: false)
      allow(Faraday).to receive(:post).and_return(fake_response)
      invitation = create(:invitation, colabora_invitation_id: 1, status: :declined)

      response = DeclineInvitationService.send_decline(invitation.colabora_invitation_id)

      expect(response).to eq false
      expect(Invitation.count).to eq 1
      expect(invitation.reload.status).to eq 'declined'
    end

    it 'falso quando acontece server error e mantém status recusado' do
      fake_response = double('faraday_response', status: 500, success?: false)
      allow(Faraday).to receive(:post).and_return(fake_response)
      invitation = create(:invitation, colabora_invitation_id: 1, status: :declined)

      response = DeclineInvitationService.send_decline(invitation.colabora_invitation_id)

      expect(response).to eq false
      expect(Invitation.count).to eq 1
      expect(invitation.reload.status).to eq 'declined'
    end

    it 'falso quando não consegue se conectar com a API e mantém status recusado' do
      invitation = create(:invitation, colabora_invitation_id: 1, status: :declined)

      response = DeclineInvitationService.send_decline(invitation.colabora_invitation_id)

      expect(response).to eq false
      expect(Invitation.count).to eq 1
      expect(invitation.reload.status).to eq 'declined'
    end
  end
end
