require 'rails_helper'

describe 'Usuário vê notificações de publicações' do
  it 'e visualiza a notificação' do
    follower = create(:user, full_name: 'Paulo')
    followed = create(:user, full_name: 'Ana')
    Connection.create!(followed_profile: followed.profile, follower: follower.profile)
    post = create(:post, user: followed)

    NewPostNotificationJob.perform_now(post)

    login_as follower
    visit notifications_path

    expect(page).to have_content 'Ana fez uma publicação'
    expect(Notification.last).to be_seen
  end

  context 'nova publicação notifica seguidores' do
    it 'com sucesso' do
      follower = create(:user, full_name: 'Paulo')
      followed = create(:user, full_name: 'Ana')
      Connection.create!(followed_profile: followed.profile, follower: follower.profile)
      new_post_notification_job_spy = spy(NewPostNotificationJob)
      stub_const('NewPostNotificationJob', new_post_notification_job_spy)
      create(:post, user: followed)

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
      expect(page).to have_content "#{like.user.full_name} curtiu sua publicação"
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

    it 'ao clicar na notificação é redirecionado para a publicação' do
      user = create(:user)
      post = create(:post, user:)
      like = create(:like, likeable: post)

      login_as user
      visit notifications_path
      click_on "#{like.user.full_name} curtiu sua publicação"

      expect(page).to have_current_path post_path(post)
      expect(Notification.last).to be_clicked
    end
  end

  it 'ao clicar na notificação é redirecionado para a publicação' do
    follower = create(:user, full_name: 'Paulo')
    followed = create(:user, full_name: 'Ana')
    Connection.create!(followed_profile: followed.profile, follower: follower.profile)
    post = create(:post, user: followed)

    NewPostNotificationJob.perform_now(post)

    login_as follower
    visit notifications_path
    click_on 'Ana fez uma publicação'

    expect(page).to have_current_path post_path(post)
    expect(Notification.last).to be_clicked
  end
end
