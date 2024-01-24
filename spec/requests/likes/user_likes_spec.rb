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
end
