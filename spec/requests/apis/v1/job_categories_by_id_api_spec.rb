require 'rails_helper'

describe 'API categorias de trabalho por id' do
  context 'GET /api/v1/job_categories/:id' do
    it 'com sucesso' do
      first_job_category = create(:job_category, name: 'Full Stack')
      create(:job_category, name: 'Web Design')

      get "/api/v1/job_categories/#{first_job_category.id}"

      expect(response).to have_http_status :ok
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse(response.body)

      expect(json_response.class).to eq Hash
      expect(json_response.keys).to include 'data'
      expect(json_response['data'].class).to eq Hash
      expect(json_response['data'].keys).not_to include 'created_at'
      expect(json_response['data'].keys).not_to include 'updated_at'
      expect(json_response['data']['id']).to eq 1
      expect(json_response['data']['name']).to eq 'Full Stack'
    end

    it 'retorna um erro 404 e mensagem de erro quando categoria não existe' do
      get '/api/v1/job_categories/99999'

      expect(response).to have_http_status :not_found

      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Hash
      expect(json_response['error']).to eq 'Não encontrado'
    end

    it 'retorna um erro interno do servidor' do
      job_category = create(:job_category, name: 'Web Design')
      allow(JobCategory).to receive(:find).and_raise(ActiveRecord::QueryCanceled)

      get "/api/v1/job_categories/#{job_category.id}"

      expect(response).to have_http_status :internal_server_error
      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Hash
      expect(json_response['error']).to eq 'Houve um erro interno no servidor ao processar sua solicitação.'
    end
  end
end
