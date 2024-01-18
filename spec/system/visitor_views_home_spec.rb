require 'rails_helper'

describe 'Usuário acessa página de cadastro de usuário' do
  it 'a partir da home' do
    visit root_path

    click_on 'Cadastrar Usuário'

    expect(current_path).to eq new_user_registration_path
  end

  it 'com sucesso' do
    visit new_user_registration_path

    expect(page).to have_field 'Nome Completo'
    expect(page).to have_field 'E-mail'
    expect(page).to have_field 'CPF'
    expect(page).to have_field 'Senha'
    expect(page).to have_field 'Confirme sua Senha'
    expect(page).to have_button 'Cadastrar'
  end

  it 'e realiza o cadastro com sucesso' do
    visit new_user_registration_path

    fill_in 'Nome Completo', with: 'João Almeida'
    fill_in 'E-mail', with: 'joaoalmeida@email.com'
    fill_in 'CPF', with: '88257290068'
    fill_in 'Senha', with: '123456'
    fill_in 'Confirme sua Senha', with: '123456'
    click_on 'Cadastrar'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Boas vindas 👋 Você realizou seu cadastro com sucesso.'
  end

  it 'e falha ao realizar o cadastro' do
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

  it 'e cria senha com menos de 6 caracteres' do
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

  it 'e tenta criar com dados inválidos' do
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

  it 'e tenta criar com dados já cadastrados' do
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

  it 'and prints message' do
    visit root_path

    fill_in 'Mensagem', with: 'Olá, pessoal!'
    click_on 'Imprimir'

    expect(page).not_to have_content 'Hello'
    expect(page).to have_css('p', text: 'Olá, pessoal!')
  end
end
