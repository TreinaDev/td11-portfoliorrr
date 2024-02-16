require 'rails_helper'

RSpec.describe InvitationRequestService::ColaBoraInvitationRequestPost do
  context '.send' do
    it 'retorna a resposta da requisição feita ao ColaBora' do
      invitation_request = create(:invitation_request)
      fake_colabora_body = File.read(Rails.root.join('./spec/support/json/proposal_201.json'))
      fake_colabora_response = double('faraday_response', status: 201, body: fake_colabora_body)
      allow(Faraday).to receive(:post).and_return(fake_colabora_response)

      response = InvitationRequestService::ColaBoraInvitationRequestPost.send(invitation_request)

      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Hash
      expect(json_response['data']['proposal_id']).to eq 1
    end
  end
end
