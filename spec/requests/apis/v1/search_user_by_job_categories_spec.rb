require 'rails_helper'

describe 'Api busca usuários por categoria de trabalho' do
  context 'GET api/v1/profiles' do
    it 'com sucesso' do
      ruby = create(:job_category, name: 'Ruby on Rails') # AB
      web_design = create(:job_category, name: 'Web Design') #CD
      user_a = create(:user)
      user_a.profile.profile_job_categories.create!(job_category: ruby, description: 'Eu uso ruby pra codar')
      user_b = create(:user, full_name: 'André Porteira', citizen_id_number: '418.767.220-61', email: 'andre@email.com')
      user_b.profile.profile_job_categories.create!(job_category: web_design, description: 'EU trabalho com css.')
      #user_c = create(:user, full_name: 'Moisés Campus', citizen_id_number: '002.488.770-62', email: 'moises@email.com')
      #user_c.profile.profile_job_categories.create!(job_category: ruby, description: 'Eu gosto de programar.')
      #user_d = create(:user, full_name: 'Eliseu Ramos', citizen_id_number: '630.010.360-95', email: 'eliseu@email.com')
      #user_d.profile.profile_job_categories.create!(job_category: web_design, description: 'Eu uso html e ruby')

      get '/api/v1/profiles/search', params: { search: 'ruby' }

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq 1
      expect(json_response.class).to eq Array
      expect(json_response.first.keys).not_to include 'created_at'
      expect(json_response.first.keys).not_to include 'updated_at'
      expect(json_response.first['id']).to eq 1
      expect(json_response.first['full_name']).to eq 'Joao Almeida'
      expect(json_response.first['job_categories']).to eq [{ name: 'Ruby on Rails' }]
      expect(json_response.second['id']).not_to eq 2
      expect(json_response.second['full_name']).not_to eq 'André Porteira'
      expect(json_response.second['job_categories']).not_to eq [{ name: 'Web Design' }]
    end

    pending 'não encontrar nenhum usuário'
    pending 'retorna um erro interno do servidor'
  end
end

# Profile.where(id: ProfileJobCategory.where.associated(:job_category).where("name LIKE '%#{search}%'").pluck(:profile_id)) >> pesquisa no nome da categoria
# Profile.where(id: ProfileJobCategory.where("description like '%#{search}%'").pluck(:profile_id)) >> pesquisa na descrição da categoria de perfil

# 'Ruby on Rails' >> search = 'ruby'