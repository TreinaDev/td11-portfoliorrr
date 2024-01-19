require 'rails_helper'

describe 'Usuário cria uma postagem no blog' do
  it 'apenas quando autenticado' do
    user = create(:user)
    visit new_user_post_path(user)

    expect(current_path).to eq new_user_session_path
  end

  it 'com sucesso' do
    user = create(:user, full_name: 'Seiya de Pégaso')

    login_as user
    visit root_path

    within 'nav' do
      click_on 'Criar Nova Publicação'
    end

    fill_in 'Título da Publicação', with: 'Olá Mundo!'
    fill_in 'Conteúdo', with: 'Primeira publicação'

    travel_to Time.zone.local(1910, 9, 1, 0, 0, 0) do
      click_on 'Salvar'
    end

    expect(Post.count).to eq 1
    expect(current_path).to eq post_path(Post.first)
    expect(page).to have_content 'Olá Mundo!'
    expect(page).to have_content 'Primeira publicação'
    expect(page).to have_content 'Criado por Seiya de Pégaso'
    expect(page).to have_content 'Publicado em: 01/09/1910'
  end

  it 'apenas no perfil da sua conta, e é redirecionado caso contrário' do
    user1 = create(:user, email: 'user1@email.com')
    user2 = create(:user, email: 'user2@email.com')

    login_as user2

    visit new_user_post_path(user1)

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não pode realizar essa ação'
  end

  it 'apenas se fornecer um título e conteúdo ao post' do
    user = create(:user)

    login_as user
    visit new_user_post_path(user)

    fill_in 'Título da Publicação', with: ''
    fill_in 'Conteúdo', with: ''

    click_on 'Salvar'

    expect(Post.count).to eq 0
    expect(page).to have_content 'Não foi possível criar sua publicação'
    expect(page).to have_content 'Título da Publicação não pode ficar em branco'
    expect(page).to have_content 'Conteúdo não pode ficar em branco'
  end

  it 'e cai em uma página de erro caso post não exista' do 
    user = create(:user)

    login_as user
    visit new_user_post_path(0)

    expect(current_path).to eq '/404'
  end
end
