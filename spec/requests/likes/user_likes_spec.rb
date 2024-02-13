require 'rails_helper'

describe 'Usuário curte uma publicação ou comentário' do
  context 'não esta logado' do
    it 'e tenta curtir' do
      post = create(:post)

      post post_likes_path(post)

      expect(response).to redirect_to(new_user_session_path)
      expect(Like.count).to eq 0
    end

    it 'e tenta descurtir uma publicação' do
      like = create(:like, :for_post)

      delete post_like_path(like.likeable, like)

      expect(response).to redirect_to(new_user_session_path)
      expect(Like.count).to eq 1
    end

    it 'e tenta descurtir um comentário' do
      like = create(:like, :for_comment)

      delete comment_like_path(like.likeable, like)

      expect(response).to redirect_to(new_user_session_path)
      expect(Like.count).to eq 1
    end
  end

  it 'e não curte duas vezes' do
    like = create(:like, :for_post)

    login_as like.user

    post post_likes_path(like.likeable)

    expect(response).to redirect_to(post_path(like.likeable))
    expect(flash[:alert]).to eq 'Você já curtiu isso'
    expect(Like.count).to eq 1
  end
end
