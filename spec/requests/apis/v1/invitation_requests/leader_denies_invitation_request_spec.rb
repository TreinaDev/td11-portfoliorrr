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

    it 'retorna erro 409 se a solicitação não estiver pendente' do
      request1 = create(:invitation_request, status: :processing)
      request2 = create(:invitation_request, status: :accepted)
      request3 = create(:invitation_request, status: :refused)
      request4 = create(:invitation_request, status: :error)
      request5 = create(:invitation_request, status: :aborted)

      response_status1 = patch "/api/v1/invitation_requests/#{request1.id}"
      response_status2 = patch "/api/v1/invitation_requests/#{request2.id}"
      response_status3 = patch "/api/v1/invitation_requests/#{request3.id}"
      response_status4 = patch "/api/v1/invitation_requests/#{request4.id}"
      response_status5 = patch "/api/v1/invitation_requests/#{request5.id}"
      request1.reload
      request2.reload
      request3.reload
      request4.reload
      request5.reload

      expect(response_status1).to eq 409
      expect(response_status2).to eq 409
      expect(response_status3).to eq 409
      expect(response_status4).to eq 409
      expect(response_status5).to eq 409
      expect(request1).to be_processing
      expect(request2).to be_accepted
      expect(request3).to be_refused
      expect(request4).to be_error
      expect(request5).to be_aborted
      expect(response.content_type).to include 'application/json'
      json_last_response = JSON.parse(response.body)
      expect(json_last_response.class).to eq Hash
      expect(json_last_response['errors']).to include 'Solicitação de convite não está pendente para ser recusada.'
    end

    it 'retorna erro 404 se a solicitação não for encontrada' do
      patch '/api/v1/invitation_requests/1939'

      expect(response.status).to eq 404
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['error']).to include 'Não encontrado'
    end

    it 'retorna erro 500, com mensagem identificando erro do servidor' do
      allow(InvitationRequest).to receive(:find).and_raise(ActiveRecord::ActiveRecordError)
      invitation_request = create(:invitation_request)
      patch "/api/v1/invitation_requests/#{invitation_request.id}"

      expect(response.status).to eq 500
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['error']).to include 'Houve um erro interno no servidor ao processar sua solicitação.'
    end
  end
end
