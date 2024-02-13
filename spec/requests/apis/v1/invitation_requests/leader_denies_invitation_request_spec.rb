require 'rails_helper'

describe 'API solicitações' do
  context 'PATCH /api/v1/invitation_requests/:id' do
    it 'altera o status para recusado com sucesso' do
      invitation_request = create(:invitation_request, status: :pending)

      patch "/api/v1/invitation_requests/#{invitation_request.id}"
      invitation_request.reload

      expect(response).to have_http_status(200)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Hash
      expect(json_response['id']).to eq invitation_request.id
      expect(json_response['profile_id']).to eq invitation_request.profile.id
      expect(json_response['message']).to eq invitation_request.message
      expect(json_response['project_id']).to eq invitation_request.project_id
      expect(json_response.keys).not_to include 'created_at'
      expect(json_response.keys).not_to include 'updated_at'
      expect(json_response['status']).to eq 'refused'
    end

    pending 'retorna erro 409 se a solicitação já estiver recusada'
    pending 'retorna erro 404 se a solicitação não for encontrada'
    pending 'retorna erro 400 se a requisição não contiver um id de solicitação de convite'
    pending 'retorna erro 500, com mensagem identificando erro do servidor'
  end
end
