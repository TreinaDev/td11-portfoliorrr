require 'rails_helper'

describe 'API projects_request_invitation', type: :request do
  context 'GET /api/v1/projects/request_invitation' do
    it 'com sucesso e recebe confirmação da criação de proposal' do
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

    it 'com sucesso, mas recebe alerta de erro 404 do Cola?Bora!' do
      invitation_request = create(:invitation_request)
      invitation_request_params = { data: { proposal: { invitation_request_id: invitation_request.id.to_s,
                                                        project_id: invitation_request.project_id.to_s,
                                                        profile_id: invitation_request.profile.id.to_s,
                                                        email: invitation_request.profile.email,
                                                        message: invitation_request.message } } }.as_json

      fake_colabora_response_body = { 'errors': ['Projeto não encontrado'] }.as_json
      fake_colabora_response = double('faraday_response', status: 404, body: fake_colabora_response_body)
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
      expect(json_response['errors']).to eq ['Projeto não encontrado']
    end

    it 'com sucesso, mas recebe alerta de erro 409 do Cola?Bora!' do
      invitation_request = create(:invitation_request)
      invitation_request_params = { data: { proposal: { invitation_request_id: invitation_request.id.to_s,
                                                        project_id: invitation_request.project_id.to_s,
                                                        profile_id: invitation_request.profile.id.to_s,
                                                        email: invitation_request.profile.email,
                                                        message: invitation_request.message } } }.as_json

      fake_colabora_response_body = { 'errors': ['Usuário já faz parte deste projeto'] }.as_json
      fake_colabora_response = double('faraday_response', status: 409, body: fake_colabora_response_body)
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
      expect(json_response['errors']).to eq ['Usuário já faz parte deste projeto']
    end

    it 'com sucesso, mas recebe alerta de erro 500 do Cola?Bora!' do
      invitation_request = create(:invitation_request)
      invitation_request_params = { data: { proposal: { invitation_request_id: invitation_request.id.to_s,
                                                        project_id: invitation_request.project_id.to_s,
                                                        profile_id: invitation_request.profile.id.to_s,
                                                        email: invitation_request.profile.email,
                                                        message: invitation_request.message } } }.as_json

      fake_colabora_response_body = { 'errors': ['Erro interno de servidor.'] }.as_json
      fake_colabora_response = double('faraday_response', status: 500, body: fake_colabora_response_body)
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
      expect(json_response['errors']).to eq ['Erro interno de servidor.']
    end

    it 'e retorna erro interno do servidor no Portfoliorrr' do
      invitation_request = create(:invitation_request)
      invitation_request_params = { data: { proposal: { invitation_request_id: invitation_request.id.to_s,
                                                        project_id: invitation_request.project_id.to_s,
                                                        profile_id: invitation_request.profile.id.to_s,
                                                        email: invitation_request.profile.email,
                                                        message: invitation_request.message } } }.as_json

      allow(Faraday).to receive(:new)
                    .with(url: 'http://localhost:3000', params: invitation_request_params['data'])
                    .and_raise(ActiveRecord::ConnectionNotEstablished)

      get '/api/v1/projects/request_invitation', params: invitation_request_params

      expect(response).to have_http_status :internal_server_error
      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Hash
      expect(json_response['error']).to eq 'Houve um erro interno no servidor ao processar sua solicitação.'
    end
  end
end
