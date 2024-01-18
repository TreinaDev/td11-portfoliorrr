require 'rails_helper'

describe 'Usuário busca outros usuários' do
  it 'apenas se autenticado' do
    visit search_profiles_path

    expect(current_path).to eq new_user_session_path
  end

  xit 'and prints message' do
    visit root_path

    fill_in 'Mensagem', with: 'Olá, pessoal!'
    click_on 'Imprimir'

    expect(page).not_to have_content 'Hello'
    expect(page).to have_css('p', text: 'Olá, pessoal!')
  end
end
