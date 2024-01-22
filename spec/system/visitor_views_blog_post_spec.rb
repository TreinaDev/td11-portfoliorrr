require 'rails_helper'

describe 'Visitante visualiza uma publicação' do
  it 'com sucesso a partir do link' do
    create(:post, title: 'Título do post', content: 'Conteúdo do post')

    visit post_path(Post.last)

    expect(current_path).to eq post_path(Post.last)
    expect(page).to have_content 'Título do post'
    expect(page).to have_content 'Conteúdo do post'
    expect(page).to have_content "Criado por #{Post.last.user.full_name}"
  end
end
