require 'rails_helper'

describe 'Usuário adiciona informações acadêmicas' do
  context 'quando logado' do
    it "e vê campo 'Exibir no Perfil' selecionado" do
      user = create(:user)

      login_as user
      visit new_user_profile_education_info_path

      expect(page).to have_checked_field 'Exibir no Perfil'
    end

    it 'com sucesso e exibe no perfil' do
      user = create(:user)

      login_as user
      visit profile_path(user.profile)
      click_on 'Adicionar Formação Acadêmica'
      fill_in 'Instituição', with: 'Campus Code'
      fill_in 'Curso', with: 'Web Dev'
      fill_in 'Início', with: '2017-12-25'
      fill_in 'Término', with: '2022-12-31'
      check 'Exibir no Perfil'
      click_on 'Salvar'

      expect(page).to have_current_path profile_path(user.profile)
      expect(page).to have_content 'Campus Code'
      expect(page).to have_content 'Web Dev'
      expect(page).to have_content '25/12/2017'
      expect(page).to have_content '31/12/2022'
      expect(page).to have_content 'Exibir no Perfil: Sim'
    end

    it 'com sucesso e não exibe no perfil' do
      user = create(:user)

      login_as user
      visit profile_path(user.profile)
      click_on 'Adicionar Formação Acadêmica'
      fill_in 'Instituição', with: 'Campus Code'
      fill_in 'Curso', with: 'Web Dev'
      fill_in 'Início', with: '2017-12-25'
      fill_in 'Término', with: '2022-12-31'
      uncheck 'Exibir no Perfil'
      click_on 'Salvar'

      expect(page).to have_current_path profile_path(user.profile)
      expect(page).to have_content 'Campus Code'
      expect(page).to have_content 'Exibir no Perfil: Não'
    end

    it 'e os campos "Instituição", "Curso" e "Início" e "Término" são obrigatórios' do
      user = create(:user)

      login_as user
      visit new_user_profile_education_info_path
      fill_in 'Instituição', with: ''
      fill_in 'Curso', with: ''
      fill_in 'Início', with: ''
      fill_in 'Término', with: ''
      check 'Exibir no Perfil'
      click_on 'Salvar'

      expect(current_path).to eq new_user_profile_education_info_path
      expect(page).to have_content 'Não foi possível cadastrar formação acadêmica'
      expect(page).to have_content 'Instituição não pode ficar em branco'
      expect(page).to have_content 'Curso não pode ficar em branco'
      expect(page).to have_content 'Início não pode ficar em branco'
      expect(page).to have_content 'Término não pode ficar em branco'
    end

    it 'e tem a opção de voltar para a página anterior' do
      user = create(:user)

      login_as user
      visit new_user_profile_education_info_path

      expect(page).to have_link 'Voltar', href: profile_path(user.profile)
    end
  end
end
