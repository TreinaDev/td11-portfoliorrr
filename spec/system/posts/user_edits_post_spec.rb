require 'rails_helper'

describe 'Usuário edita uma publicação' do
  it 'apenas autenticado' do
    post = create(:post)

    visit edit_post_path(post)

    expect(page).to have_current_path new_user_session_path
  end

  it 'com sucesso' do
    user = create(:user)
    post = create(:post, user:, title: 'Nova publicação', content: 'Novidade', tag_list: 'tagA, tagC')

    login_as user
    visit post_path(post)
    click_on 'Editar'
    fill_in 'Título da Publicação', with: 'O título mudou'
    fill_in_rich_text_area 'conteudo', with: 'A publicação também'
    fill_in 'Tags', with: 'tagA, tagB, tagC'
    travel_to Time.zone.local(2025, 9, 7, 0, 0, 0) do
      click_on 'Salvar'
    end

    expect(page).to have_current_path post_path(post)
    expect(page).to have_content 'Publicação editada com sucesso!'
    expect(page).to have_content 'O título mudou'
    expect(page).to have_content 'A publicação também'
    expect(page).to have_content "Última atualização em: #{I18n.l(post.created_at.to_datetime, format: :long)}"
    expect(page).to have_content '#tagA #tagB #tagC'
  end

  it 'e é redirecionado ao tentar atualizar publicação que não é sua' do
    user = create(:user, email: 'paulo@email.com', citizen_id_number: '61328427056')
    post = create(:post)

    login_as user
    visit edit_post_path(post)

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não pode realizar essa ação'
  end

  it 'mas não vê o link de editar caso não seja seu post' do
    user = create(:user, email: 'email@provider.com', citizen_id_number: '61328427056')
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
    fill_in_rich_text_area 'conteudo', with: ''
    click_on 'Salvar'

    expect(page).to have_content 'A publicação não pôde ser editada'
    expect(page).to have_content 'Título da Publicação não pode ficar em branco'
    expect(page).to have_content 'Conteúdo não pode ficar em branco'
  end

  it 'e fixa no topo da listagem' do
    user = create(:user)
    post = create(:post, user:, title: 'Post A', content: 'Primeira postagem')

    login_as user
    visit profile_path(user)
    within "div#post-#{post.id}" do
      click_on 'Fixar'
    end

    within 'div#fixed' do
      expect(page).to have_content 'Destaque'
      expect(page).to have_content post.title
      expect(page).to have_content "Publicado por: #{post.user.full_name}"
    end
    within '#publications' do
      expect(page).not_to have_content post.title
    end
    expect(page).to have_content 'Publicação fixada com sucesso!'
  end

  it 'e desfixa do topo da listagem' do
    user = create(:user)
    post = create(:post, user:, title: 'Post A', content: 'Primeira postagem', pin: 'pinned')

    login_as user
    visit profile_path(user)
    within 'div#fixed' do
      click_on 'Desfixar'
    end

    expect(page).not_to have_content 'Destaque'

    within '#publications' do
      expect(page).to have_content post.title
      expect(page).to have_content "Publicado por: #{post.user.full_name}"
    end
    expect(page).to have_content 'Publicação desfixada com sucesso!'
  end

  it 'e não fixa outras publicações' do
    user = create(:user)
    post = create(:post, user:, title: 'Post A', content: 'Primeira postagem')
    post2 = create(:post, user:, title: 'Post B', content: 'Segunda postagem')

    login_as user
    visit profile_path(user)
    within "div#post-#{post.id}" do
      click_on 'Fixar'
    end

    within '#publications' do
      expect(page).to have_content post2.title
      expect(page).to have_content "Publicado por: #{post2.user.full_name}"
    end

    within '#fixed' do
      expect(page).to have_content post.title
      expect(page).to have_content "Publicado por: #{post.user.full_name}"
    end
  end

  it 'e botão de fixar e desfixar não aparece para outros usuários' do
    user = create(:user)
    create(:post, user:, title: 'Post A', content: 'Primeira postagem', pin: 'pinned')
    create(:post, user:, title: 'Post B', content: 'Segunda postagem', pin: 'unpinned')
    other_user = create(:user, citizen_id_number: '61328427056', email: 'visitor@email.com')

    login_as other_user
    visit profile_path(user)

    expect(page).not_to have_content 'Fixar'
    expect(page).not_to have_content 'Desfixar'
  end
end
