require 'rails_helper'

describe 'API projects_request_invitation', type: :request do
  context 'GET /api/v1/projects/request_invitation' do
    it 'envia POST request à API Cola?Bora! com sucesso' do
      invitation_request = create(:invitation_request)
      invitation_request_params = { data: { proposal: { invitation_request_id: invitation_request.id.to_s,
                                                        project_id: invitation_request.project_id.to_s,
                                                        profile_id: invitation_request.profile.id.to_s,
                                                        email: invitation_request.profile.email,
                                                        message: invitation_request.message } } }.as_json
      json_proposal_response = File.read(Rails.root.join('./spec/support/json/proposal_201.json'))
      fake_colabora_response = double('faraday_response', status: 201, body: json_proposal_response)
      colabora_api_connection = double('Faraday::Connection', post: fake_colabora_response)

      allow(Faraday).to receive(:new)
                    .with(url: 'http://localhost:3000', params: invitation_request_params['data'])
        .and_return(colabora_api_connection)
      allow(colabora_api_connection)
        .to receive(:post)
        .with('/api/v1/proposals')
        .and_return(fake_colabora_response)

      get '/api/v1/projects/request_invitation', params: invitation_request_params

      expect(response).to have_http_status :ok
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Hash
      expect(json_response['data']['proposal_id']).to eq 1
    end
  end
end
