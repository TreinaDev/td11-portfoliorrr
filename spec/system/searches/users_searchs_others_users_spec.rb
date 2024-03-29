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
    fill_in 'Buscar', with: 'gErAl'
    click_on 'Pesquisar'

    expect(page).to have_content('2 resultados para: gErAl')
    expect(page).not_to have_content 'Horácio Fernandes'
    expect(page).to have_link 'Geraldo José'
    expect(page).to have_link 'Geralda'
    expect(page).to have_content 'São Paulo'
    expect(page).to have_content 'Cuiabá'
    expect(page).to have_content 'Ruby on Rails'
    within 'h2' do
      expect(page).to have_content 'Resultados da Pesquisa'
    end
    expect(current_path).to eq searches_path
  end

  it 'e não encontra nenhum usuário' do
    user = create(:user, full_name: 'Geralda')

    login_as user
    visit root_path
    fill_in 'Buscar', with: 'Dorotéia'
    click_on 'Pesquisar'

    expect(page).to have_content 'Nenhum resultado encontrado com: Dorotéia'
  end

  it 'mas não vê o formulário por não estar logado' do
    visit root_path

    expect(page).not_to have_field 'Busca de Perfis'
    expect(page).not_to have_button 'Pesquisar'
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
    fill_in 'Buscar', with: 'jo'
    click_on 'Pesquisar'

    expect(page).to have_link('João').once
  end

  it 'e não encontra perfis desativados' do
    user = create(:user)
    other_user = create(:user, full_name: 'Carla')
    other_user.profile.inactive!

    login_as user
    visit root_path
    fill_in 'Buscar', with: 'Carla'
    click_on 'Pesquisar'

    expect(page).not_to have_link('Carla')
    expect(page).to have_content 'Nenhum resultado encontrado com: Carla'
  end
end
