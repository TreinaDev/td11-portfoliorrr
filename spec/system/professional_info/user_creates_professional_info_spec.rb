require 'rails_helper'

describe 'Usuário adiciona informações profissionais' do
  context 'quando logado' do
    it 'com sucesso' do
      user = create(:user)

      login_as user
      visit profile_path(user.profile)
      click_on 'Adicionar Experiência Profissional'
      fill_in 'Empresa', with: 'Rebase'
      fill_in 'Cargo', with: 'Desenvolvedor Python'
      fill_in 'Data de Entrada', with: '2017-12-25'
      fill_in 'Data de Saída', with: '2022-12-31'
      fill_in 'Descrição', with: 'Trabalhava muito'
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

    context 'como emprego atual' do
      it 'e os campos "Empresa", "Cargo" e "Data de Entrada" são obrigatórios' do
        user = create(:user)

        login_as user

        visit new_user_profile_professional_info_path

        check 'Vínculo Atual'
        fill_in 'Empresa', with: ''
        fill_in 'Cargo', with: ''
        fill_in 'Data de Entrada', with: ''
        fill_in 'Data de Saída', with: ''
        check 'Exibir no Perfil'

        click_on 'Salvar'

        expect(page).to have_current_path new_user_profile_professional_info_path

        expect(page).to have_content 'Não foi possível cadastrar experiência profissional'
        expect(page).to have_content 'Empresa não pode ficar em branco'
        expect(page).to have_content 'Cargo não pode ficar em branco'
        expect(page).to have_content 'Data de Entrada não pode ficar em branco'
      end
    end

    context 'como emprego passado' do
      it 'e os campos "Empresa", "Cargo", "Data de Entrada" e "Data de Saída" são obrigatórios' do
        user = create(:user)

        login_as user

        visit new_user_profile_professional_info_path

        fill_in 'Empresa', with: ''
        fill_in 'Cargo', with: ''
        fill_in 'Data de Entrada', with: ''
        fill_in 'Data de Saída', with: ''
        check 'Exibir no Perfil'

        click_on 'Salvar'

        expect(page).to have_current_path new_user_profile_professional_info_path

        expect(page).to have_content 'Não foi possível cadastrar experiência profissional'
        expect(page).to have_content 'Empresa não pode ficar em branco'
        expect(page).to have_content 'Cargo não pode ficar em branco'
        expect(page).to have_content 'Data de Entrada não pode ficar em branco'
        expect(page).to have_content 'Data de Saída não pode ficar em branco'
      end
    end

    it 'e tem a opção de voltar para a página anterior' do
      user = create(:user)
      create(:professional_info, profile: user.profile)

      login_as user

      visit new_user_profile_professional_info_path

      expect(page).to have_link 'Voltar', href: profile_path(user.profile)
    end
  end
end
