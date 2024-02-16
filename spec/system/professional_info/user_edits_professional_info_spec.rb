require 'rails_helper'

describe 'Usuário edita informações profissionais' do
  context 'quando logado' do
    it 'com sucesso' do
      user = create(:user)
      create(:professional_info, profile: user.profile)

      login_as user
      visit profile_path(user.profile)
      click_on 'Editar Experiência Profissional'

      expect(page).to have_content 'Experiência Profissional'

      fill_in 'Empresa', with: 'Rebase'
      fill_in 'Cargo', with: 'Desenvolvedor Python'
      fill_in 'Data de Entrada', with: '2017-12-25'
      fill_in 'Data de Saída', with: '2022-12-31'
      fill_in 'Descrição', with: 'Trabalhava muito'

      expect(page).to have_unchecked_field 'Vínculo Atual'

      check 'Exibir no Perfil'

      click_on 'Salvar'

      expect(page).to have_current_path profile_path(user.profile)
      expect(page).to have_content 'Rebase'
      expect(page).to have_content 'Vínculo Atual: Não'
      expect(page).to have_content 'Desenvolvedor Python'
      expect(page).to have_content 'Trabalhava muito'
      expect(page).to have_content '25/12/2017'
      expect(page).to have_content '31/12/2022'
    end

    it 'e os campos "Empresa", "Cargo" e "Data de Entrada" são obrigatórios' do
      user = create(:user)
      professional_info = create(:professional_info, profile: user.profile)

      login_as user
      visit edit_professional_info_path(professional_info)
      fill_in 'Empresa', with: ''
      fill_in 'Cargo', with: ''
      fill_in 'Data de Entrada', with: ''
      fill_in 'Data de Saída', with: ''
      check 'Exibir no Perfil'

      click_on 'Salvar'

      expect(page).to have_current_path edit_professional_info_path(professional_info)

      expect(page).to have_content 'Não foi possível atualizar experiência profissional'
      expect(page).to have_content 'Empresa não pode ficar em branco'
      expect(page).to have_content 'Cargo não pode ficar em branco'
      expect(page).to have_content 'Data de Entrada não pode ficar em branco'
    end

    it 'e atualiza somente alguns campos com sucesso' do
      user = create(:user)
      professional_info = create(:professional_info, profile: user.profile)

      login_as user
      visit edit_professional_info_path(professional_info)
      fill_in 'Empresa', with: 'Vindi'
      click_on 'Salvar'

      expect(page).to have_content 'Vindi'
      expect(page).to have_content user.profile.professional_infos.first.position
      expect(page).to have_content '23/01/2022'
      expect(page).to have_content '23/01/2024'
    end

    it 'e tem a opção de voltar para a página anterior' do
      user = create(:user)
      professional_info = create(:professional_info, profile: user.profile)

      login_as user

      visit edit_professional_info_path(professional_info)

      expect(page).to have_link 'Voltar', href: profile_path(user.profile)
    end
  end

  context 'quando logado como outro usuário' do
    it 'e falha' do
      user1 = create(:user)
      user2 = create(:user, email: 'user2@email.com', citizen_id_number: '10491233019')

      professional_info_user1 = create(:professional_info, profile: user1.profile)

      login_as user2

      visit edit_professional_info_path(professional_info_user1)

      expect(page).to have_current_path root_path
      expect(page).to have_content 'Não foi possível completar sua ação'
    end
  end
end
