require 'rails_helper'

describe 'API perfis de usuário' do
  context 'GET /api/v1/profiles/:id' do
    it 'com sucesso' do
      profile = create(:profile)
      2.times do
        create(:professional_info, :faked, profile:)
      end
      2.times do
        create(:education_info, :faked, profile:)
      end
      2.times do
        job_category = create(:job_category)
        create(:profile_job_category, job_category:, profile:)
      end

      get "/api/v1/profiles/#{profile.id}"

      expect(response.status).to eq 200
      json_response = JSON.parse(response.body)
      expect(json_response['data'].count).to eq 7
      expect(json_response['data']['profile_id']).to eq profile.id
      expect(json_response['data']['email']).to eq profile.user.email
      expect(json_response['data']['full_name']).to eq profile.user.full_name
      expect(json_response['data']['cover_letter']).to eq profile.cover_letter
      expect(json_response['data']['professional_infos'].first['company']).to eq profile.professional_infos.first
                                                                                        .company
      expect(json_response['data']['professional_infos'].first['position']).to eq profile.professional_infos.first
                                                                                         .position
      expect(json_response['data']['professional_infos'].first['start_date']).to eq profile.professional_infos.first
                                                                                           .start_date.to_s
      expect(json_response['data']['professional_infos'].first['end_date']).to eq profile.professional_infos.first
                                                                                         .end_date.to_s
      expect(json_response['data']['professional_infos'].first['current_job']).to eq profile.professional_infos.first
                                                                                            .current_job
      expect(json_response['data']['professional_infos'].last['company']).to eq profile.professional_infos.last
                                                                                       .company
      expect(json_response['data']['professional_infos'].last['position']).to eq profile.professional_infos.last
                                                                                        .position
      expect(json_response['data']['professional_infos'].last['start_date']).to eq profile.professional_infos.last
                                                                                          .start_date.to_s
      expect(json_response['data']['professional_infos'].last['end_date']).to eq profile.professional_infos.last
                                                                                        .end_date.to_s
      expect(json_response['data']['professional_infos'].last['current_job']).to eq profile.professional_infos.last
                                                                                           .current_job
      expect(json_response['data']['education_infos'].first['institution']).to eq profile.education_infos.first
                                                                                         .institution
      expect(json_response['data']['education_infos'].first['course']).to eq profile.education_infos.first
                                                                                    .course
      expect(json_response['data']['education_infos'].first['start_date']).to eq profile.education_infos.first
                                                                                        .start_date.to_s
      expect(json_response['data']['education_infos'].first['end_date']).to eq profile.education_infos.first
                                                                                      .end_date.to_s
      expect(json_response['data']['education_infos'].last['institution']).to eq profile.education_infos.last
                                                                                        .institution
      expect(json_response['data']['education_infos'].last['course']).to eq profile.education_infos.last
                                                                                   .course
      expect(json_response['data']['education_infos'].last['start_date']).to eq profile.education_infos.last
                                                                                       .start_date.to_s
      expect(json_response['data']['education_infos'].last['end_date']).to eq profile.education_infos.last
                                                                                     .end_date.to_s
      expect(json_response['data']['job_categories'].first['name']).to eq profile.profile_job_categories.first
                                                                                 .job_category.name
      expect(json_response['data']['job_categories'].first['description']).to eq profile.profile_job_categories.first
                                                                                        .description
      expect(json_response['data']['job_categories'].last['name']).to eq profile.profile_job_categories.last
                                                                                .job_category.name
      expect(json_response['data']['job_categories'].last['description']).to eq profile.profile_job_categories.last
                                                                                       .description
    end

    it 'recebe apenas campos relevantes' do
      profile = create(:profile)
      create(:professional_info, :faked, profile:)
      create(:education_info, :faked, profile:)
      job_category = create(:job_category)
      create(:profile_job_category, job_category:, profile:)

      get "/api/v1/profiles/#{profile.id}"

      expect(response.status).to eq 200
      json_response = JSON.parse(response.body)
      expect(json_response['data'].count).to eq 7
      expect(json_response['data']['professional_infos'].first).not_to include 'id'
      expect(json_response['data']['professional_infos'].first).not_to include 'visibility'
      expect(json_response['data']['professional_infos'].first).not_to include 'profile_id'
      expect(json_response['data']['professional_infos'].first).not_to include 'created_at'
      expect(json_response['data']['professional_infos'].first).not_to include 'updated_at'
      expect(json_response['data']['education_infos'].first).not_to include 'id'
      expect(json_response['data']['education_infos'].first).not_to include 'visibility'
      expect(json_response['data']['education_infos'].first).not_to include 'profile_id'
      expect(json_response['data']['education_infos'].first).not_to include 'created_at'
      expect(json_response['data']['education_infos'].first).not_to include 'updated_at'
      expect(json_response['data']['job_categories'].first).not_to include 'id'
      expect(json_response['data']['job_categories'].first).not_to include 'profile_id'
      expect(json_response['data']['job_categories'].first).not_to include 'job_category_id'
      expect(json_response['data']['job_categories'].first).not_to include 'created_at'
      expect(json_response['data']['job_categories'].first).not_to include 'updated_at'
    end

    it 'retorna um erro caso o perfil não exista' do
      get '/api/v1/profiles/314159265359'

      expect(response.status).to eq 404
      json_response = JSON.parse(response.body)
      expect(json_response['error']).to eq 'Perfil não existe.'
    end

    it 'retorna um erro caso o perfil esteja inativo' do
      profile = create(:profile, status: 'inactive')

      get "/api/v1/profiles/#{profile.id}"

      expect(response.status).to eq 404
      json_response = JSON.parse(response.body)
      expect(json_response['error']).to eq 'Perfil não existe.'
    end

    it 'retorna um erro interno do servidor' do
      allow(Profile).to receive(:active).and_raise(ActiveRecord::ConnectionFailed)

      get '/api/v1/profiles/1'

      expect(response.status).to eq 500
      json_response = JSON.parse(response.body)
      expect(json_response['error']).to eq 'Houve um erro interno no servidor ao processar sua solicitação.'
    end
  end
end
