require 'rails_helper'

describe 'Usuário busca outros usuários' do
  it 'com sucesso e vê lista de perfis encontrados' do
    user = create(:user, full_name: 'Horácio Fernandes', email: 'horacio@email.com', citizen_id_number: '00752496263')
    another_user = create(:user, full_name: 'Geralda', citizen_id_number: '02742567895')
    other_user = create(:user, full_name: 'Geraldo José', email: 'geraldo@email.com', citizen_id_number: '00232728305')
    another_user.profile.personal_info.update!(city: 'São Paulo', state: 'São Paulo')
    other_user.profile.personal_info.update!(city: 'Cuiabá', state: 'Mato Grosso')
    job_category = create(:job_category, name: 'Ruby on Rails')
    another_user.profile.profile_job_categories.create!(job_category:)

    login_as user
    visit root_path
    fill_in 'Buscar Perfil', with: 'gErAl'
    click_on 'Pesquisar'

    expect(current_path).to eq search_profiles_path
    expect(page).to have_content('2 resultados para: gErAl')
    expect(page).not_to have_content 'Horácio Fernandes'
    expect(page).to have_link 'Geraldo José'
    expect(page).to have_link 'Geralda'
    expect(page).to have_content 'São Paulo'
    expect(page).to have_content 'Cuiabá'
    expect(page).to have_content 'Ruby on Rails'
    within 'h2' do
      expect(page).to have_content 'Resultado da Pesquisa'
    end
  end

  it 'e não encontra nenhum usuário' do
    user = create(:user, full_name: 'Geralda')

    login_as user
    visit root_path
    fill_in 'Buscar Perfil', with: 'Dorotéia'
    click_on 'Pesquisar'

    expect(page).to have_content 'Nenhum perfil encontrado com: Dorotéia'
  end

  it 'só pode ver página de resultados se estiver logado' do
    visit search_profiles_path

    expect(current_path).to eq new_user_session_path
  end

  it 'mas não vê o formulário por não estar logado' do
    visit root_path

    expect(page).not_to have_field 'Busca de Perfis'
    expect(page).not_to have_button 'Pesquisar'
  end

  it 'mas campo de pesquisa não pode ficar em branco' do
    user = create(:user)

    login_as user
    visit root_path
    fill_in 'Buscar Perfil', with: ''
    click_on 'Pesquisar'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você precisa informar um nome para fazer a pesquisa'
  end

  it 'e usuário só aparece uma vez' do
    user = create(:user, full_name: 'João')
    first_job_category = create(:job_category, name: 'Jornalista')
    second_job_category = create(:job_category, name: 'Jogador')
    user.profile.personal_info.update!(city: 'São João')
    user.profile.profile_job_categories.create!(job_category: first_job_category)
    user.profile.profile_job_categories.create!(job_category: second_job_category)

    login_as user
    visit root_path
    fill_in 'Buscar Perfil', with: 'jo'
    click_on 'Pesquisar'

    expect(page).to have_link('João').once
  end
end
