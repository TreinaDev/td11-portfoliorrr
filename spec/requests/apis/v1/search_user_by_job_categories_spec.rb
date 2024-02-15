require 'rails_helper'

describe 'Api busca usuários por categoria de trabalho' do
  context 'GET api/v1/profiles' do
    it 'com sucesso se encontrar o parâmetro no nome da categoria ou na descrição dela' do
      ruby = create(:job_category, name: 'Ruby on Rails')
      web_design = create(:job_category, name: 'Web Design')
      front_end = create(:job_category, name: 'Front End')
      user_a = create(:user, full_name: 'Joao Almeida')
      user_a.profile.profile_job_categories.create!(job_category: ruby, description: 'Eu amo codar')
      user_b = create(:user, full_name: 'André Porteira')
      user_b.profile.profile_job_categories.create!(job_category: web_design, description: 'EU trabalho com css.')
      user_c = create(:user, full_name: 'Moisés Campus')
      user_c.profile.profile_job_categories.create!(job_category: web_design, description: 'Eu uso ruby')
      user_c.profile.profile_job_categories.create!(job_category: front_end, description: 'Eu uso Bootstrap.')
      user_d = create(:user, full_name: 'Eliseu Ramos')
      user_d.profile.unavailable!
      user_d.profile.profile_job_categories.create!(job_category: ruby, description: 'Eu amo ruby.')

      get '/api/v1/profiles', params: { search: 'ruby' }

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['data'].count).to eq 2
      expect(json_response['data'].class).to eq Array
      expect(json_response['data'].first.keys).not_to include 'created_at'
      expect(json_response['data'].first.keys).not_to include 'updated_at'
      expect(json_response['data'].first['user_id']).to eq 1
      expect(json_response['data'].first['full_name']).to eq 'Joao Almeida'
      expect(json_response['data'].first['job_categories']).to eq [{ 'title' => 'Ruby on Rails',
                                                                     'description' => 'Eu amo codar' }]
      expect(json_response['data'].second['user_id']).to eq 3
      expect(json_response['data'].second['full_name']).to eq 'Moisés Campus'
      expect(json_response['data'].second['job_categories']).to eq [{ 'title' => 'Web Design',
                                                                      'description' => 'Eu uso ruby' },
                                                                    { 'title' => 'Front End',
                                                                      'description' => 'Eu uso Bootstrap.' }]
    end

    it 'e retorna array vazio ao não encontrar nenhum usuário' do
      user = create(:user)
      python = create(:job_category, name: 'Python')
      user.profile.profile_job_categories.create(job_category: python, description: 'Uso Django.')

      get '/api/v1/profiles', params: { search: 'ruby' }

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['data']).to eq []
    end

    it 'e retorna a lista de todos os usuários quando não recebe um parâmetro de busca' do
      ruby = create(:job_category, name: 'Ruby on Rails')
      first_user = create(:user, full_name: 'Joao Almeida')
      first_user.profile.profile_job_categories.create(job_category: ruby, description: 'Especialista em Ruby.')
      create(:user, full_name: 'André Porteira')
      create(:user, full_name: 'Eliseu Ramos').profile.unavailable!

      get '/api/v1/profiles', params: { search: '' }

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['data'].count).to eq 2
      expect(json_response['data'].class).to eq Array
      expect(json_response['data'].first.keys).not_to include 'created_at'
      expect(json_response['data'].first.keys).not_to include 'updated_at'
      expect(json_response['data'].first['profile_id']).to eq 2
      expect(json_response['data'].first['full_name']).to eq 'André Porteira'
      expect(json_response['data'].first['job_categories']).to eq []
      expect(json_response['data'].second['profile_id']).to eq 1
      expect(json_response['data'].second['full_name']).to eq 'Joao Almeida'
      expect(json_response['data'].second['job_categories']).to eq [{ 'name' => 'Ruby on Rails',
                                                                      'description' => 'Especialista em Ruby.' }]
    end

    it 'retorna um erro interno do servidor' do
      allow(Profile).to receive(:get_profile_job_categories_json).and_raise(ActiveRecord::ConnectionFailed)

      get '/api/v1/profiles', params: { search: 'ruby' }

      expect(response.status).to eq 500
      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Hash
      expect(json_response['error']).to eq 'Houve um erro interno no servidor ao processar sua solicitação.'
    end

    it 'retorna perfis premium primeiro e depois os perfis comuns' do
      create(:user, :free, full_name: 'Eliseu Ramos')
      create(:user, :free, full_name: 'André Porteira')
      create(:user, full_name: 'Moisés Campus')
      create(:user, full_name: 'Joao Almeida')

      get '/api/v1/profiles'

      expect(response.status).to eq 200
      json_response = JSON.parse(response.body)
      expect(json_response['data'].count).to eq 4
      expect(json_response['data'].first['full_name']).to eq 'Joao Almeida'
      expect(json_response['data'].second['full_name']).to eq 'Moisés Campus'
      expect(json_response['data'].third['full_name']).to eq 'André Porteira'
      expect(json_response['data'].fourth['full_name']).to eq 'Eliseu Ramos'
    end

    it 'retorna perfis premium primeiro e depois os perfis free na busca com parâmetro' do
      ruby = create(:job_category, name: 'Ruby on Rails')

      user_premium = create(:user, full_name: 'Moisés Campus')
      user_premium.profile.profile_job_categories.create(job_category: ruby, description: 'Sou um especialista em Ruby')
      user_free = create(:user, :free, full_name: 'André Almeida')
      user_free.profile.profile_job_categories.create(job_category: ruby, description: 'Fiz um e-commerce em Ruby')

      get '/api/v1/profiles', params: { search: 'ruby' }

      expect(response.status).to eq 200
      json_response = JSON.parse(response.body)
      expect(json_response['data'].count).to eq 2
      expect(json_response['data'].first['full_name']).to eq 'Moisés Campus'
      expect(json_response['data'].second['full_name']).to eq 'André Almeida'
    end
  end
end
