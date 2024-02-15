require 'rails_helper'

describe 'Usuário deleta categoria de trabalho' do
  it 'do seu perfil com sucesso' do
    user = create(:user, full_name: 'Zelda Hyrule')
    job_category = create(:job_category, name: 'Luta com espada')
    job_category_two = create(:job_category, name: 'Magia')
    ProfileJobCategory.create!(job_category:, profile: user.profile, description: 'Eu sou muito bom nessa categoria')
    ProfileJobCategory.create!(job_category: job_category_two, profile: user.profile)

    login_as user
    visit profile_path(user.profile)
    page.all('.btn-delete-category').to_a.second.click

    expect(ProfileJobCategory.count).to eq 1
    expect(page).to have_content 'Eu sou muito bom nessa categoria'
    expect(page).to have_content 'Categoria de trabalho deletada com sucesso!'
    expect(page).to have_content 'Luta com espada'
    expect(page).not_to have_content 'Magia'
  end

  it 'e não consegue ver o botão em outro perfil' do
    user = create(:user, full_name: 'Zelda Hyrule')
    other_user = create(:user)
    job_category = create(:job_category, name: 'Luta com espada')
    job_category_two = create(:job_category, name: 'Magia')
    ProfileJobCategory.create!(job_category:, profile: user.profile, description: 'Eu sou muito bom nessa categoria')
    ProfileJobCategory.create!(job_category: job_category_two, profile: user.profile)

    login_as other_user
    visit profile_path(user.profile)

    expect(page).to have_content 'Zelda Hyrule'
    expect(page).to have_content 'Luta com espada'
    expect(page).to have_content 'Magia'
    expect(page.all('.btn-delete-category').count).to eq 0
  end
end
