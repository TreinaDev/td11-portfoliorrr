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

  pending 'com sucesso e vê uma lista de nomes de usuários cadastrados'
end
