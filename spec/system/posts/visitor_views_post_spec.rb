require 'rails_helper'

describe 'Visitante visualiza uma publicação' do
  it 'com sucesso a partir do link' do
    post = create(:post, title: 'Título do post', content: 'Conteúdo do post')

    visit post_path(post)

    expect(current_path).to eq post_path(post)
    expect(page).to have_content 'Título do post'
    expect(page).to have_content 'Conteúdo do post'
    expect(page).to have_content "Criado por #{post.user.full_name}"
  end

  it 'e não vê arquivada' do
    post = create(:post, title: 'Título do post', content: 'Conteúdo do post', status: 'archived')

    visit post_path(post)

    expect(page).to have_current_path(root_path)
    expect(page).to have_content 'Você não pode acessar este conteúdo ou realizar esta ação'
  end

  it 'e não vê rascunho' do
    post = create(:post, title: 'Título do post', content: 'Conteúdo do post', status: 'draft')

    visit post_path(post)

    expect(page).to have_current_path(root_path)
    expect(page).to have_content 'Você não pode acessar este conteúdo ou realizar esta ação'
  end

  it 'e não vê post removido' do
    post = create(:post, title: 'Título do post', content: 'Conteúdo do post', status: 'removed')

    visit post_path(post)

    expect(page).to have_current_path(root_path)
    expect(page).to have_content 'Você não pode acessar este conteúdo ou realizar esta ação'
  end

  it 'e nâo vê comentário removido' do
    user = create(:user)
    post = create(:post, title: 'Título do post', content: 'Conteúdo do post',
                         status: 'published', published_at: Time.zone.now)
    create(:comment, post:, status: :published, message: 'Primeiro comentário')
    create(:comment, post:, status: :removed, message: 'Segundo comentário')
    create(:comment, post:, status: :published, message: 'Terceiro comentário')

    login_as user
    visit post_path(post)

    within '#comments' do
      expect(page).to have_content 'Primeiro comentário'
      expect(page).not_to have_content 'Segundo comentário'
      expect(page).to have_content 'Terceiro comentário'
      expect(page).to have_content 'Comentário removido pela administração'
    end
  end
end
