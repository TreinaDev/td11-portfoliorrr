require 'rails_helper'

describe 'Usuário edita informações sobre sua formação' do
  context 'quando logado' do
    it 'com sucesso' do
      user = create(:user)
      create(:education_info, profile: user.profile)

      login_as user
      visit profile_path(user.profile)
      click_on 'Editar Formação Acadêmica'
      fill_in 'Instituição', with: 'UFJF'
      fill_in 'Curso', with: 'Bacharelado em Ciência da Computação'
      fill_in 'Início', with: '2012-12-25'
      fill_in 'Término', with: '2015-12-31'
      check 'Exibir no Perfil'
      click_on 'Salvar'

      expect(page).to have_current_path profile_path(user.profile)
      expect(page).to have_content 'UFJF'
      expect(page).to have_content 'Bacharelado em Ciência da Computação'
      expect(page).to have_content '25/12/2012'
      expect(page).to have_content '31/12/2015'
    end

    it 'e campos "Instituição", "Curso", "Início" e "Término" são obrigatórios' do
      user = create(:user)

      education_info = create(:education_info, profile: user.profile)

      login_as user
      visit profile_path(user.profile)
      click_on 'Editar Formação Acadêmica'
      fill_in 'Instituição', with: ''
      fill_in 'Curso', with: ''
      fill_in 'Início', with: ''
      fill_in 'Término', with: ''
      check 'Exibir no Perfil'
      click_on 'Salvar'

      expect(current_path).to eq edit_education_info_path(education_info)
      expect(page).to have_content 'Não foi possível atualizar formação acadêmica'
      expect(page).to have_content 'Instituição não pode ficar em branco'
      expect(page).to have_content 'Curso não pode ficar em branco'
      expect(page).to have_content 'Início não pode ficar em branco'
      expect(page).to have_content 'Término não pode ficar em branco'
    end

    it 'e atualiza somente alguns campos com sucesso' do
      user = create(:user)
      education_info = create(:education_info, profile: user.profile)

      login_as user
      visit edit_education_info_path(education_info)
      fill_in 'Instituição', with: 'USP'
      click_on 'Salvar'

      expect(page).to have_content 'USP'
      expect(page).to have_content education_info.course
      expect(page).to have_content education_info.start_date.strftime('%d/%m/%Y')
      expect(page).to have_content education_info.end_date.strftime('%d/%m/%Y')
    end

    it 'e tem a opção de voltar para a página anterior' do
      user = create(:user)
      education_info = create(:education_info, profile: user.profile)

      login_as user
      visit edit_education_info_path(education_info)

      expect(page).to have_link 'Voltar', href: profile_path(user.profile)
    end
  end
end
