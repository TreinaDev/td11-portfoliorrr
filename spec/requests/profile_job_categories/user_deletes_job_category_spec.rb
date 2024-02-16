require 'rails_helper'

describe 'Usuário remove categoria de trabalho' do
  it 'mas precisa estar logado' do
    user = create(:user, full_name: 'Zelda Hyrule')
    job_category = create(:job_category, name: 'Luta com espada')
    job_category_two = create(:job_category, name: 'Magia')
    ProfileJobCategory.create!(job_category:, profile: user.profile, description: 'Eu sou muito bom nessa categoria')
    ProfileJobCategory.create!(job_category: job_category_two, profile: user.profile)

    delete profile_job_category_path job_category

    expect(response).to redirect_to new_user_session_path
    expect(flash[:alert]).to eq 'Para continuar, faça login ou registre-se.'
  end

  it 'mas precisa ser dono da categoria' do
    user = create(:user, full_name: 'Zelda Hyrule')
    another_user = create(:user)
    job_category = create(:job_category, name: 'Luta com espada')
    job_category_two = create(:job_category, name: 'Magia')
    ProfileJobCategory.create!(job_category:, profile: user.profile, description: 'Eu sou muito bom nessa categoria')
    ProfileJobCategory.create!(job_category: job_category_two, profile: user.profile)

    login_as another_user
    delete profile_job_category_path job_category

    expect(response).to redirect_to profile_path(another_user.profile)
    expect(flash[:alert]).to eq 'Você não têm permissão para realizar essa ação.'
  end
end
