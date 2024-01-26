require 'rails_helper'

describe 'Usuário adiciona informações acadêmicas' do
  context 'quando logado' do
    it 'com sucesso' do
      user = create(:user)

      login_as user

      visit user_profile_path

      click_on 'Adicionar Formação Acadêmica'

      fill_in 'Instituição', with: 'Campus Code'
      fill_in 'Curso', with: 'Web Dev'
      fill_in 'Início', with: '2017-12-25'
      fill_in 'Término', with: '2022-12-31'

      check 'Visível'

      click_on 'Salvar'

      expect(current_path).to eq user_profile_path
      expect(page).to have_content 'Campus Code'
      expect(page).to have_content 'Web Dev'
      expect(page).to have_content '25/12/2017'
      expect(page).to have_content '31/12/2022'
      expect(page).to have_content 'Visível: Sim'
    end

    it 'e os campos "Instituição", "Curso" e "Início" e "Término" são obrigatórios' do
      user = create(:user)

      login_as user

      visit new_user_profile_education_info_path

      fill_in 'Instituição', with: ''
      fill_in 'Curso', with: ''
      fill_in 'Início', with: ''
      fill_in 'Término', with: ''
      check 'Visível'

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

      expect(page).to have_link 'Voltar', href: root_path
    end
  end
end
