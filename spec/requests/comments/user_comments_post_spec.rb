require 'rails_helper'

describe 'Usuário faz um comentário' do
  it 'não esta logado e é redirecionado' do
    post = create(:post)

    post post_comments_path(post)

    expect(response).to redirect_to(new_user_session_path)
  end
end
