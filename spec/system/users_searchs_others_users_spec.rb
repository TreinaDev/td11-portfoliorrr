require 'rails_helper'

describe 'Usuário busca outros usuários' do
  it 'apenas se autenticado' do
    visit search_profiles_path

    expect(current_path).to eq new_user_session_path
  end

  it 'a partir da página inicial' do
    user = create(:user)

    login_as user
    visit root_path

    within 'header' do
      expect(page).to have_field 'Busca de Perfis'
      expect(page).to have_button 'Pesquisar'
    end
  end

  it 'mas não vê o formulário por não estar logado' do
    visit root_path

    expect(page).not_to have_field 'Busca de Perfis'
    expect(page).not_to have_button 'Pesquisar'
  end

  it 'com sucesso e vê uma lista de nomes de usuários cadastrados' do
    create(:user, full_name: 'Horácio Fernandes', email: 'horacio@email.com')
    create(:user, full_name: 'Geraldo José', email: 'geraldo@email.com')
    user = create(:user, full_name: 'Geralda')

    login_as user
    visit root_path
    fill_in 'Busca de Perfis', with: 'gErAl'
    click_on 'Pesquisar'

    expect(current_path).to eq search_profiles_path
    expect(page).not_to have_content 'Horácio Fernandes'
    expect(page).to have_content 'Geraldo José'
    expect(page).to have_content 'Geralda'
    within 'h2' do
      expect(page).to have_content 'Resultado da Pesquisa'
    end
  end

  it 'e não encontra nenhum usuário' do
    user = create(:user, full_name: 'Geralda')

    login_as user
    visit root_path
    fill_in 'Busca de Perfis', with: 'Dorotéia'
    click_on 'Pesquisar'

    expect(page).to have_content 'Não encontramos nenhum perfil com esse nome'
  end

  it 'mas recebe um alerta de erro por não preencher o campo de pesquisa' do
    user = create(:user)

    login_as user
    visit root_path
    fill_in 'Busca de Perfis', with: ''
    click_on 'Pesquisar'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você precisa informar um nome para pesquisar'
  end
end
