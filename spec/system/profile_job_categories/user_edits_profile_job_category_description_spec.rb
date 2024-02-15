require 'rails_helper'

describe 'Usuário edita descrição de categoria de trabalho em seu perfil' do
  it 'com sucesso' do
    user = create(:user, full_name: 'Zelda Hyrule')
    job_category = create(:job_category, name: 'Luta com espada')
    job_category_two = create(:job_category, name: 'Magia')
    ProfileJobCategory.create!(job_category:, profile: user.profile)
    ProfileJobCategory.create!(job_category: job_category_two, profile: user.profile,
                               description: 'Simples descrição inicial')

    login_as user
    visit profile_path(user.profile)
    page.all('.btn-edit-category').to_a.second.click
    fill_in 'Descrição', with: 'Nova descrição para minha categoria'
    click_on 'Salvar'

    expect(page).to have_content 'Categoria de trabalho editada com sucesso!'
    expect(page).not_to have_content 'Simples descrição inicial'
    expect(page).to have_content 'Nova descrição para minha categoria'
  end

  it 'não pode alterar de outro usuário' do
    user = create(:user, full_name: 'Zelda Hyrule')
    another_user = create(:user)
    job_category = create(:job_category, name: 'Luta com espada')
    job_category_two = create(:job_category, name: 'Magia')
    profile_job_category = ProfileJobCategory.create!(job_category:, profile: user.profile)
    ProfileJobCategory.create!(job_category: job_category_two, profile: user.profile,
                               description: 'Simples descrição inicial')

    login_as another_user
    visit edit_profile_job_category_path(profile_job_category)

    expect(page).to have_current_path profile_path(another_user.profile)
    expect(page).to have_content 'Você não têm permissão para realizar essa ação'
  end

  it 'e precisa estar logado' do
    user = create(:user, full_name: 'Zelda Hyrule')
    job_category = create(:job_category, name: 'Luta com espada')
    profile_job_category = ProfileJobCategory.create!(job_category:, profile: user.profile)

    visit edit_profile_job_category_path(profile_job_category)

    expect(page).to have_current_path new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se'
  end

  it 'e não vê botão de editar categoria em perfil alheio' do
    user = create(:user, full_name: 'Zelda Hyrule')
    another_user = create(:user)
    job_category = create(:job_category, name: 'Luta com espada')
    job_category_two = create(:job_category, name: 'Magia')
    ProfileJobCategory.create!(job_category:, profile: user.profile)
    ProfileJobCategory.create!(job_category: job_category_two, profile: user.profile,
                               description: 'Simples descrição inicial')

    login_as another_user
    visit profile_path(user.profile)

    expect(page.all('.btn-edit-category').count).to eq 0
  end
end
