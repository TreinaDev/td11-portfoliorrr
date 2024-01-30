require 'rails_helper'

describe 'Api busca usuários por categoria de trabalho' do
  context 'GET api/v1/profiles' do
    it 'com sucesso se encontrar o parâmetro no nome da categoria ou na descrição dela' do
      ruby = create(:job_category, name: 'Ruby on Rails')
      web_design = create(:job_category, name: 'Web Design')
      front_end = create(:job_category, name: 'Front End')
      user_a = create(:user, full_name: 'Joao Almeida')
      user_a.profile.profile_job_categories.create!(job_category: ruby, description: 'Eu amo codar')
      user_b = create(:user, full_name: 'André Porteira', citizen_id_number: '418.767.220-61', email: 'andre@email.com')
      user_b.profile.profile_job_categories.create!(job_category: web_design, description: 'EU trabalho com css.')
      user_c = create(:user, full_name: 'Moisés Campus', citizen_id_number: '002.488.770-62', email: 'moises@email.com')
      user_c.profile.profile_job_categories.create!(job_category: web_design, description: 'Eu uso ruby')
      user_c.profile.profile_job_categories.create!(job_category: front_end, description: 'Eu uso Bootstrap.')

      get '/api/v1/profiles/search', params: { search: 'ruby' }

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq 2
      expect(json_response.class).to eq Array
      expect(json_response.first.keys).not_to include 'created_at'
      expect(json_response.first.keys).not_to include 'updated_at'
      expect(json_response.first['user_id']).to eq 1
      expect(json_response.first['full_name']).to eq 'Joao Almeida'
      expect(json_response.first['job_categories']).to eq [{ 'title' => 'Ruby on Rails',
                                                             'description' => 'Eu amo codar' }]
      expect(json_response.second['user_id']).to eq 3
      expect(json_response.second['full_name']).to eq 'Moisés Campus'
      expect(json_response.second['job_categories']).to eq [{ 'title' => 'Web Design', 'description' => 'Eu uso ruby' },
                                                            { 'title' => 'Front End',
                                                              'description' => 'Eu uso Bootstrap.' }]
    end

    it 'e retorna array vazio ao não encontrar nenhum usuário' do
      user = create(:user)
      python = create(:job_category, name: 'Python')
      user.profile.profile_job_categories.create(job_category: python, description: 'Uso Django.')

      get '/api/v1/profiles/search', params: { search: 'ruby' }

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      expect(JSON.parse(response.body)).to eq []
    end

    it 'e não recebe um parâmetro de busca' do
      get '/api/v1/profiles/search', params: { search: '' }

      expect(response.status).to eq 400
      expect(response.content_type).to include 'application/json'
      expect(JSON.parse(response.body)).to eq({ 'error' => 'É necessário fornecer um parâmetro de busca' })
    end

    it 'retorna um erro interno do servidor' do
      allow(Profile).to receive(:get_profile_job_categories_json).and_raise(ActiveRecord::ConnectionFailed)

      get '/api/v1/profiles/search', params: { search: 'ruby' }

      expect(response.status).to eq 500
      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Hash
      expect(json_response['error']).to eq 'Houve um erro interno no servidor ao processar sua solicitação.'
    end
  end
end
