require 'rails_helper'

describe 'Usuário edita post' do
  it 'e tenta alterar data de publicação de post publicado' do
    post = create(:post, status: :published, published_at: 1.day.from_now)

    login_as post.user
    patch(post_path(post), params: { post: { published_at: 2.days.from_now } })

    expect(Post.last.published_at).to eq post.published_at
  end
end
