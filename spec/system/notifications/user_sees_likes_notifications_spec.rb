require 'rails_helper'

describe 'Usuário vê notificação de nova curtida' do
  context 'com sucesso' do
    it 'em seu post' do
      user = create(:user)
      post = create(:post, user:)
      like = create(:like, likeable: post)

      login_as user
      visit root_path
      click_button class: 'dropdown-toggle'
      within 'nav' do
        click_on 'Notificações'
      end

      expect(page).to have_current_path notifications_path
      expect(page).to have_content 'curtiu sua publicação'
      expect(page).to have_link like.user.full_name, href: profile_path(like.user.profile)
    end

    it 'em seu comentário' do
      user = create(:user)
      post = create(:post)
      comment = create(:comment, post:, user:)
      like = create(:like, likeable: comment)

      login_as user
      visit root_path
      click_button class: 'dropdown-toggle'
      within 'nav' do
        click_on 'Notificações'
      end

      expect(page).to have_current_path notifications_path
      expect(page).to have_content 'curtiu seu comentário'
      expect(page).to have_link like.user.profile.full_name, href: profile_path(like.user.profile)
    end
  end

  context 'e não recebe notificação de seu like' do
    it 'em sua própria publicação' do
      user = create(:user)
      post = create(:post, user:)
      like = create(:like, likeable: post, user:)

      login_as user
      visit root_path
      click_button class: 'dropdown-toggle'
      within 'nav' do
        click_on 'Notificações'
      end

      expect(page).not_to have_content 'curtiu sua publicação'
      expect(page).not_to have_link like.user.profile.full_name, href: profile_path(like.user.profile)
    end

    it 'em seu próprio comentário' do
      user = create(:user)
      post = create(:post)
      comment = create(:comment, post:, user:)
      like = create(:like, likeable: comment, user:)

      login_as user
      visit root_path
      click_button class: 'dropdown-toggle'
      within 'nav' do
        click_on 'Notificações'
      end

      expect(page).not_to have_content 'curtiu seu comentário'
      expect(page).not_to have_link like.user.profile.full_name, href: profile_path(like.user.profile)
    end
  end
end
