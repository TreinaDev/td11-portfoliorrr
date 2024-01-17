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
    expect(page).to have_field 'Confirmação da Senha'
    expect(page).to have_button 'Cadastrar'
  end

  it 'and prints message' do
    visit root_path

    fill_in 'Mensagem', with: 'Olá, pessoal!'
    click_on 'Imprimir'

    expect(page).not_to have_content 'Hello'
    expect(page).to have_css('p', text: 'Olá, pessoal!')
  end
end
