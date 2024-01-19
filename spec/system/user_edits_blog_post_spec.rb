require 'rails_helper'

describe 'Usuário edita uma publicação do blog' do
  it 'apenas autenticado' do 
    post = create(:post)

    visit edit_post_path(post)

    expect(current_path).to eq new_user_session_path 
  end

  it 'com sucesso' do
    user = create(:user)
    post = create(:post, user:, title: 'Nova publicação', content: 'Novidade')
    
    login_as user
    visit post_path(post)
    click_on 'Editar'
    fill_in 'Título da Publicação', with: 'O título mudou'
    fill_in 'Conteúdo', with: 'A publicação também'
    travel_to Time.zone.local(2025, 9, 7, 0, 0, 0) do
      click_on 'Salvar'
    end
    
    expect(current_path).to eq post_path(post)
    expect(page).to have_content 'Publicação editada com sucesso!'
    expect(page).to have_content 'O título mudou'
    expect(page).to have_content 'A publicação também'
    expect(page).to have_content 'Última atualização em: 07/09/2025'
  end

  it 'e é redirecionado ao tentar atualizar publicação que não é sua' do
    user = create(:user, email: 'paulo@email.com')
    post = create(:post)

    login_as user
    visit edit_post_path(post)

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não pode realizar essa ação'
  end
  
  it 'mas não vê o link de editar caso não seja seu post' do
    user = create(:user, email: 'email@provider.com')
    post = create(:post)

    login_as user
    visit post_path(post)

    expect(page).not_to have_link 'Editar', href: edit_post_path(post)
  end

  it 'com dados incompletos e recebe erro' do
    post = create(:post, title: 'Nova publicação', content: 'Novidade')
    
    login_as post.user
    visit edit_post_path(post)
    fill_in 'Título da Publicação', with: ''
    fill_in 'Conteúdo', with: ''
    click_on 'Salvar'

    expect(page).to have_content 'A publicação não pode ser editada'
    expect(page).to have_content 'Título da Publicação não pode ficar em branco'
    expect(page).to have_content 'Conteúdo não pode ficar em branco'
  end

  it 'e cai em uma página de erro caso post não exista' do
    user = create(:user)

    login_as user
    visit edit_post_path(1)

    expect(current_path).to eq '/404'
  end
end
