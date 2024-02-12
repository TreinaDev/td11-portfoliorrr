require 'rails_helper'

describe 'Usuário curte' do
  context 'Uma publicação' do
    it 'com sucesso' do
      post = create(:post, title: 'Publicação do Teste')
      user = create(:user, email: 'user@email.com', citizen_id_number: '028.998.450-55')

      login_as user
      visit post_path(post)
      click_button id: 'like'

      expect(page).to have_content('1 Curtida')
      expect(page).not_to have_selector('#like')
      expect(page).to have_selector('#unlike')
    end

    it 'e deixa de curtir' do
      like = create(:like, :for_post)

      login_as like.user
      visit post_path(like.likeable)
      click_button id: 'unlike'

      expect(page).to have_content '0 Curtida'
      expect(page).to have_selector '#like'
      expect(Like.count).to eq 0
    end
  end

  context 'Um comentário' do
    it 'com sucesso' do
      post = create(:post)
      user = create(:user, email: 'user@email.com', citizen_id_number: '028.998.450-55')
      create(:comment, post:, user:)

      login_as user
      visit post_path(post)
      within '#comments' do
        click_button id: 'like'
      end

      expect(page).to have_content('1 Curtida')
      within '#comments' do
        expect(page).not_to have_selector('#like')
      end
      expect(page).to have_selector('#unlike')
    end

    it 'e deixa de curtir' do
      like = create(:like, :for_comment)

      login_as like.user
      visit post_path(like.likeable.post)
      within '#comments' do
        click_button id: 'unlike'

        expect(page).to have_content '0 Curtida'
        expect(page).to have_selector '#like'
      end
      expect(Like.count).to eq 0
    end
  end
end
