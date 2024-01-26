require 'rails_helper'

describe 'Usuário curte uma publicação ou comentário' do
  context 'não esta logado' do
    it 'e tenta curtir' do
      post likes_path

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'e tenta descurtir uma publicação' do
      like = create(:like, :for_post)

      delete like_path(like)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'e tenta descurtir um comentário' do
      like = create(:like, :for_comment)

      delete like_path(like)

      expect(response).to redirect_to(new_user_session_path)
    end
  end

  it 'e não curte duas vezes' do
    like = create(:like, :for_post)

    login_as like.user

    post likes_path, params: { post_id: like.likeable.id }

    expect(response).to redirect_to(post_path(like.likeable))
    expect(flash[:alert]).to eq 'Você já curtiu isso'
  end
end
