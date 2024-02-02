require 'rails_helper'

describe 'Usuário acessa página de cadastro de usuário' do
  it 'a partir da home com sucesso' do
    visit root_path
    click_on 'Criar Nova Conta'
    fill_in 'Nome Completo', with: 'João Almeida'
    fill_in 'E-mail', with: 'joaoalmeida@email.com'
    fill_in 'CPF', with: '88257290068'
    fill_in 'Senha', with: '123456'
    fill_in 'Confirme sua Senha', with: '123456'
    click_on 'Cadastrar'

    profile = User.last.profile
    expect(profile).to be_present
    expect(page).to have_content 'Boas vindas 👋 Você realizou seu cadastro com sucesso.'
  end

  context 'e realiza o cadastro com falhas' do
    it 'campos não podem ficar em brancos' do
      visit new_user_registration_path
      fill_in 'Nome Completo', with: ''
      fill_in 'E-mail', with: ''
      fill_in 'CPF', with: ''
      fill_in 'Senha', with: ''
      fill_in 'Confirme sua Senha', with: ''
      click_on 'Cadastrar'

      expect(page).to have_content 'Não foi possível salvar usuário'
      expect(page).to have_content 'Nome Completo não pode ficar em branco'
      expect(page).to have_content 'E-mail não pode ficar em branco'
      expect(page).to have_content 'CPF não pode ficar em branco'
      expect(page).to have_content 'Senha não pode ficar em branco'
    end

    it 'senha não pode ter menos de 6 caracteres' do
      visit new_user_registration_path
      fill_in 'Nome Completo', with: 'João Almeida'
      fill_in 'E-mail', with: 'joaoalmeida@email.com'
      fill_in 'CPF', with: '88257290068'
      fill_in 'Senha', with: '1234'
      fill_in 'Confirme sua Senha', with: '1234'
      click_on 'Cadastrar'

      expect(page).to have_content 'Não foi possível salvar usuário'
      expect(page).to have_content 'Senha é muito curto (mínimo: 6 caracteres)'
    end

    it 'com CPF ou confirmação de senha inválidos' do
      visit new_user_registration_path

      fill_in 'Nome Completo', with: 'João Almeida'
      fill_in 'E-mail', with: 'joaoalmeida@email.com'
      fill_in 'CPF', with: '88257290060'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirme sua Senha', with: '123467'
      click_on 'Cadastrar'

      expect(page).to have_content 'Não foi possível salvar usuário'
      expect(page).to have_content 'Confirme sua Senha não é igual a Senha'
      expect(page).to have_content 'CPF inválido'
    end

    it 'CPF e e-mail devem ser únicos' do
      create(:user, email: 'joaoalmeida@email.com', citizen_id_number: '88257290068')

      visit new_user_registration_path
      fill_in 'Nome Completo', with: 'João Almeida'
      fill_in 'E-mail', with: 'joaoalmeida@email.com'
      fill_in 'CPF', with: '88257290068'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirme sua Senha', with: '123456'
      click_on 'Cadastrar'

      expect(page).to have_content 'Não foi possível salvar usuário'
      expect(page).to have_content 'E-mail já está em uso'
      expect(page).to have_content 'CPF já está em uso'
    end

    it 'e pula a etapa de registro de dados pessoais' do
      visit new_user_registration_path
      fill_in 'Nome Completo', with: 'João Almeida'
      fill_in 'E-mail', with: 'joaoalmeida@email.com'
      fill_in 'CPF', with: '88257290068'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirme sua Senha', with: '123456'
      click_on 'Cadastrar'
      click_link 'Preencher Depois'

      expect(current_path).to eq root_path
    end
  end
end
