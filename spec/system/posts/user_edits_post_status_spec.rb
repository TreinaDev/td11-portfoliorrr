require 'rails_helper'

describe 'Usuário edita status da publicação' do
  it 'com sucesso, ao arquivar' do
    post = create(:post)

    login_as post.user
    visit edit_post_path(post)
    choose 'Arquivada'
    click_on 'Salvar'

    expect(page).to have_current_path post_path(post)
    expect(Post.last.status).to eq 'archived'
  end

  it 'com sucesso, ao mudar para rascunho' do
    post = create(:post)

    login_as post.user
    visit edit_post_path(post)
    choose 'Rascunho'
    click_on 'Salvar'

    expect(page).to have_current_path post_path(post)
    expect(Post.last.status).to eq 'draft'
    expect(page).to have_content('Status: Rascunho')
  end

  it 'publica rascunho' do
    post = create(:post, status: 'draft')

    login_as post.user
    visit edit_post_path(post)
    choose 'Publicada'
    click_on 'Salvar'

    expect(page).to have_current_path post_path(post)
    expect(Post.last.status).to eq 'published'
    expect(page).to have_content('Status: Publicada')
  end
end
