require 'rails_helper'

describe 'Usuário comenta uma publicação' do
  it 'com sucesso' do
    post = create(:post)

    login_as post.user
    visit post_path(post)
    fill_in 'Mensagem', with: 'Um comentário legal'
    click_on 'Comentar'

    expect(page).to have_content 'Um comentário legal'
    expect(post).to be_persisted
  end

  it 'e deve estar logado' do
    post = create(:post)

    visit post_path(post)

    expect(page).not_to have_field 'Mensagem'
    expect(page).not_to have_button 'Comentar'
  end

  it 'com mensagem em branco' do
    post = create(:post)

    login_as post.user
    visit post_path(post)
    fill_in 'Mensagem', with: ''
    click_on 'Comentar'

    expect(page).to have_content 'Não foi possível fazer o comentário'
    expect(Comment.count).to eq 0
  end
end
