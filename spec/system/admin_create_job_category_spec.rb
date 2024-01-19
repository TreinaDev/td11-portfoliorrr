require 'rails_helper'

describe 'Usuário cria categoria de trabalho' do
  it 'com sucesso' do
    admin = create(:user, :admin)

    login_as admin
    visit job_categories_path
    fill_in 'Nome da categoria', with: 'Web Design'
    click_on 'Criar'

    expect(page).to have_current_path(job_categories_path)
    expect(page).to have_content('Categoria de Trabalho criada com sucesso!')
    expect(page).to have_content('Web Design')
  end

  it 'e deve estar logado' do
    visit job_categories_path

    expect(current_path).to eq(new_user_session_path)
    expect(page).to have_content('Para continuar, faça login ou registre-se.')
  end

  it 'e deve ser administrador' do
    user = create(:user)

    login_as user
    visit job_categories_path

    expect(page).to have_current_path(root_path)
    expect(page).to have_content('Você não têm permissão para realizar essa ação.')
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

  it 'com dados faltando' do
    admin = create(:user, :admin)

    login_as admin
    visit job_categories_path
    click_on 'Criar'

    expect(page).to have_content('Não foi possível cadastrar Categoria de Trabalho.')
    expect(page).to have_content('Nome não pode ficar em branco')
  end
end
