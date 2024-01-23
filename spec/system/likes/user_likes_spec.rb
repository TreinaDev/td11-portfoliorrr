require 'rails_helper'

describe 'Usuário curte' do
  context 'Uma publicação' do
    it 'com sucesso' do
      post = create(:post)
      user = create(:user, email: 'user@email.com', citizen_id_number: '028.998.450-55')

      login_as user
      visit post_path(post)
      click_on 'Curtir'

      expect(page).to have_content('Você curtiu esta publicação')
      expect(page).to have_content('1 Curtida')
      expect(page).not_to have_content('Curtir')
      expect(page).to have_content('Descurtir')
    end

    it 'e deixa de curtir' do
      user = create(:user)
      post = create(:post, user:)
      like = create(:like, user:, post:)

      login_as user
      visit post_path(like.post)
      click_on 'Descurtir'

      expect(page).to have_content '0 Curtida'
      expect(page).to have_content 'Curtir'
      expect(Like.count).to eq 0
    end
  end
end
