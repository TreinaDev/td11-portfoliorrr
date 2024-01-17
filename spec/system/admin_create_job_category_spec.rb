require 'rails_helper'

describe 'Usuário cria categoria de trabalho' do
  it 'deve estar logado' do
    visit job_categories_path

    expect(current_path).to eq(new_user_session_path)
    expect(page).to have_content('Para continuar, faça login ou registre-se.')
  end

  it 'a partir do menu' do
    user = create(:user, :admin)

    login_as user
    visit root_path
    click_on 'Categorias de trabalho'

    expect(page).to have_current_path(job_categories_path)
    expect(page).to have_content('Cadastro de categorias de trabalho')
    expect(page).to have_field('Nome da categoria')
    expect(page).to have_button('Criar')
  end
end
