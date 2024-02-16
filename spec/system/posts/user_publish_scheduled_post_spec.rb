require 'rails_helper'

describe 'Usuário publica um post agendado' do
  it 'comm sucesso' do
    post = create(:post, status: :scheduled, published_at: 1.day.from_now)

    login_as post.user
    visit post_path(post)
    click_on 'Publicar'

    expect(page).to have_content 'Publicada com sucesso'
    expect(page).to have_content 'Publicada'
    expect(post.reload).to be_published
    expect(page).not_to have_button 'Publicar'
  end
end
