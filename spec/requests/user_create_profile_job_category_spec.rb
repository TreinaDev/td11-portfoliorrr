require 'rails_helper'

describe 'Usuário cadastra categoria de trabalho em seu perfil' do
  it 'com sucesso' do
    user = create(:user)
    job_category = create(:job_category, name: 'Luta com espadas')

    login_as user
    post profile_job_categories_path, params: { profile_job_category: { job_category_id: job_category.id, 
                                                                        description: 'Sou um Jedi' } }

    expect(response).to redirect_to(user_profile_path)
    expect(ProfileJobCategory.all).not_to be_empty
    expect(ProfileJobCategory.first.profile).to eq user.profile
    expect(ProfileJobCategory.first.job_category).to eq job_category
    expect(ProfileJobCategory.first.description).to eq 'Sou um Jedi'
  end

  it 'apenas quando autenticado' do
    job_category = create(:job_category, name: 'Luta com espadas')

    post profile_job_categories_path, params: { profile_job_category: { job_category_id: job_category.id, 
                                                                        description: 'Sou um Jedi' } }
    
    expect(response).to redirect_to(new_user_session_path)
    expect(ProfileJobCategory.all).to be_empty
  end

  it 'apenas para sua própria conta' do
    hacker = create(:user, email: 'hacker@vilao.com', citizen_id_number: '65315399095')
    user = create(:user)
    job_category = create(:job_category)

    login_as hacker
    post profile_job_categories_path, params: { profile_job_category: { job_category_id: job_category.id, 
                                                                        description: 'Sou muito malvado',
                                                                        profile_id: user.id } }

    expect(user.profile.profile_job_categories).to be_empty
  end
end