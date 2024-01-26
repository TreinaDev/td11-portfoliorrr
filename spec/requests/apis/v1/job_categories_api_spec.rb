require 'rails_helper'

describe 'API categorias de trabalho' do
  context 'GET /api/v1/job_categories' do
    it 'com sucesso' do
      create(:job_category, name: 'Full Stack')
      create(:job_category, name: 'Web Design')
      create(:job_category, name: 'Ruby on Rails')

      get '/api/v1/job_categories'

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Array
      expect(json_response.count).to eq 3
      expect(json_response.first.keys).not_to include 'created_at'
      expect(json_response.first.keys).not_to include 'updated_at'
      expect(json_response.first['id']).to eq 1
      expect(json_response.first['name']).to eq 'Full Stack'
      expect(json_response.second['id']).to eq 2
      expect(json_response.second['name']).to eq 'Web Design'
      expect(json_response.third['id']).to eq 3
      expect(json_response.third['name']).to eq 'Ruby on Rails'
    end

    it 'retorna um aviso de que não existem categorias cadastradas' do
      get '/api/v1/job_categories'

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Hash
      empty_job_category_alert = 'Não há categorias de trabalho cadastradas. Contate um admin do Portfoliorrr.'
      expect(json_response['message']).to eq empty_job_category_alert
    end

    it 'retorna um erro interno do servidor' do
      allow(JobCategory).to receive(:all).and_raise(ActiveRecord::QueryCanceled)

      get '/api/v1/job_categories'

      expect(response.status).to eq 500
      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Hash
      expect(json_response['error']).to eq 'Houve um erro interno no servidor ao processar sua solicitação.'
    end
  end
end
