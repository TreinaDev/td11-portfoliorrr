require 'rails_helper'

describe 'Usuário edita informações pessoais' do
  context 'quando logado' do
    it 'a partir da home' do
      personal_info = create(:personal_info)

      login_as personal_info.profile.user
      visit root_path
      click_on 'Meu Perfil'
      click_on 'Editar Informações Pessoais'
      expect(current_path).to eq edit_user_profile_path
    end

    it 'com sucesso' do
      personal_info = create(:personal_info)
      login_as personal_info.profile.user

      visit edit_user_profile_path

      fill_in 'Resumo Pessoal', with: 'Eu estou tentando ser um dev melhor...'

      fill_in 'Rua', with: 'Avenida Campus Code'
      fill_in 'Número', with: '1230'
      fill_in 'Bairro', with: 'TreinaDev'
      fill_in 'Cidade', with: 'São Paulo'
      fill_in 'Estado', with: 'SP'
      fill_in 'CEP', with: '34123069'
      fill_in 'Telefone', with: '11 4002 8922'
      fill_in 'Data de Nascimento', with: '1980-12-25'

      click_on 'Salvar'

      expect(current_path).to eq user_profile_path
      expect(page).to have_content 'Eu estou tentando ser um dev melhor...'
      expect(page).to have_content 'Avenida Campus Code'
      expect(page).to have_content '1230'
      expect(page).to have_content 'TreinaDev'
      expect(page).to have_content 'São Paulo'
      expect(page).to have_content 'SP'
      expect(page).to have_content '34123069'
      expect(page).to have_content '11 4002 8922'
      expect(page).to have_content '25/12/1980'
    end
  end

  context 'quando não logado' do
    it 'e é redirecionado para a tela de login' do
      visit edit_user_profile_path

      expect(current_path).to eq new_user_session_path
      expect(page).to have_content 'Para continuar, faça login ou registre-se'
    end
  end
end
