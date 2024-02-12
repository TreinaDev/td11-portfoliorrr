require 'rails_helper'

describe 'Usuário vê notificações de publicações' do
  context 'Nova publicação envia notificação para seguidores' do
    it 'com sucesso' do
      follower = create(:user, full_name: 'Paulo')
      followed = create(:user, full_name: 'Ana')
      Connection.create!(followed_profile: followed.profile, follower: follower.profile)
      new_post_notification_job_spy = spy(NewPostNotificationJob)
      stub_const('NewPostNotificationJob', new_post_notification_job_spy)
      create(:post, user: followed)

      login_as follower
      visit notifications_path
      
      expect(page).to have_current_path notifications_path
      expect(new_post_notification_job_spy).to have_received(:perform_later)
    end
  end

  context 'e vê curtidas' do
    it 'em seu post' do
      user = create(:user)
      post = create(:post, user:)
      like = create(:like, likeable: post)

      login_as user
      visit notifications_path

      expect(page).to have_current_path notifications_path
      expect(page).to have_content 'curtiu sua publicação'
      expect(page).to have_link like.user.full_name, href: profile_path(like.user.profile)
    end

    it 'e não recebe quando curte sua própria publicação' do
      user = create(:user)
      post = create(:post, user:)
      like = create(:like, likeable: post, user:)

      login_as user
      visit notifications_path

      expect(page).not_to have_content 'curtiu sua publicação'
      expect(page).not_to have_link like.user.profile.full_name, href: profile_path(like.user.profile)
    end
  end
end
