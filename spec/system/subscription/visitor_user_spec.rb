require 'rails_helper'

describe 'Visitante' do
  it 'Visitante acessa página de inscrições e é redirecionado' do
    visit subscriptions_path

    expect(page).to have_current_path new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end
end
