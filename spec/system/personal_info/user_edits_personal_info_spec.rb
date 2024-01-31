require 'rails_helper'

describe 'Usuário edita informações pessoais' do
  context 'quando logado' do
    it 'a partir da home' do
      user = create(:user)
      create(:personal_info, profile: user.profile)
      user_name = user.description

      login_as user
      visit root_path
      click_on user_name
      click_on 'Editar Informações Pessoais'

      expect(page).to have_current_path edit_user_profile_path
      expect(page).not_to have_link 'Preencher Depois', href: root_path
      expect(page).to have_link 'Voltar', href: profile_path(user.profile)
    end

    it 'com sucesso' do
      user = create(:user)

      login_as user

      visit edit_user_profile_path

      fill_in 'Resumo Profissional', with: 'Eu estou tentando ser um dev melhor...'

      fill_in 'Rua', with: 'Avenida Campus Code'
      fill_in 'Número', with: '1230'
      fill_in 'Bairro', with: 'TreinaDev'
      fill_in 'Cidade', with: 'São Paulo'
      select 'São Paulo', from: 'Estado'
      fill_in 'CEP', with: '08720234'
      fill_in 'Telefone', with: '11 4002 8922'
      fill_in 'Data de Nascimento', with: '1980-12-25'
      check 'Visível', id: 'profile_personal_info_attributes_visibility'

      click_on 'Salvar'

      expect(page).to have_current_path profile_path(user.profile)
      expect(user.personal_info.state).to eq 'SP'
      expect(page).to have_content 'Eu estou tentando ser um dev melhor...'
      expect(page).to have_content 'Avenida Campus Code'
      expect(page).to have_content '1230'
      expect(page).to have_content 'TreinaDev'
      expect(page).to have_content 'São Paulo'
      expect(page).to have_content 'SP'
      expect(page).to have_content '08720234'
      expect(page).to have_content '11 4002 8922'
      expect(page).to have_content '25/12/1980'
      expect(page).to have_content 'Visível: Sim'
    end

    it 'e tem a opção de voltar para a página anterior' do
      user = create(:user)

      login_as user

      visit edit_user_profile_path

      expect(page).to have_link 'Voltar', href: profile_path(user.profile)
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
