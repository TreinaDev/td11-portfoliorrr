require 'rails_helper'

describe 'Usuário visita página de configurações' do
  it 'com sucesso' do
    user = create(:user)

    login_as user
    visit root_path
    click_button class: 'dropdown-toggle'
    click_on 'Configurações'

    within 'h2' do
      expect(page).to have_content 'Configurações'
    end
    expect(page).to have_content 'Todos os dados relacionados ao seu perfil serão ARQUIVADOS'
    expect(page).to have_button 'Desativar Perfil'
    expect(page).to have_content 'Todos os dados relacionados a conta serão EXCLUÍDOS e não poderão ser recuperados'
    expect(page).to have_button 'Excluir Conta'
  end

  it 'e deleta conta' do
    user = create(:user)

    login_as user
    visit profile_settings_path(user)
    accept_prompt do
      click_on 'Excluir Conta'
    end

    expect(page).to have_current_path root_path
    expect(page).to have_content 'Conta excluída com sucesso'
  end

  it 'e desativa perfil' do
    user = create(:user)

    login_as user
    visit profile_settings_path(user)
    accept_prompt do
      click_on 'Desativar Perfil'
    end

    expect(page).to have_current_path root_path
    expect(page).to have_content 'Perfil desativado com sucesso'
  end

  it 'e não pode visitar configurações de outros usuários' do
    user = create(:user)
    other_user = create(:user)

    login_as other_user
    visit profile_settings_path(user)

    expect(page).to have_current_path root_path
    expect(page).to have_content 'Você não têm permissão para realizar essa ação.'
  end
end
