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
    expect(page).to have_content 'Você não pode realizar essa ação'
  end

  it 'e não vê rascunho' do
    post = create(:post, title: 'Título do post', content: 'Conteúdo do post', status: 'draft')

    visit post_path(post)

    expect(page).to have_current_path(root_path)
    expect(page).to have_content 'Você não pode realizar essa ação'
  end
end
