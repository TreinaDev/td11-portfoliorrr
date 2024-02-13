require 'rails_helper'

RSpec.describe InvitationRequestService::ProjectIdRetriever do
  context '.send' do
    it 'retorna o ID do projeto associado a um convite' do
      user = create(:user)
      create(:invitation_request, profile: user.profile,
                                  project_id: 1, status: :pending)
      create(:invitation_request, profile: user.profile,
                                  project_id: 2, status: :pending)

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

      invitation = create(:invitation, profile: user.profile, colabora_invitation_id: 1)

      project_id = InvitationRequestService::ProjectIdRetriever.send(invitation)

      expect(project_id).to eq 2
    end
  end
end
