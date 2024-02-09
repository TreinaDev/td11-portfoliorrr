require 'rails_helper'

describe 'Usuário vê notificações' do
  it 'com sucesso' do
    user = create(:user)
    other_user = create(:user)
    Connection.create!(follower: user.profile, followed_profile: other_user.profile)
    Connection.create!(follower: other_user.profile, followed_profile: user.profile)
    post = create(:post, user:)

    new_post_notification_job_spy = spy(NewPostNotificationJob)
    stub_const('NewPostNotificationJob', new_post_notification_job_spy)

    create(:post, user: other_user)
    create(:like, likeable: post, user: other_user)
    create(:comment, post:, user: other_user)
    comment_user = create(:comment, post:, user:)
    create(:like, likeable: comment_user, user: other_user)
    create(:invitation, profile: user.profile)

    login_as user
    visit root_path
    click_button class: 'dropdown-toggle'
    within 'nav' do
      click_on 'Notificações'
    end

    expect(page).to have_current_path notifications_path
    expect(new_post_notification_job_spy).to have_received(:perform_later)
    expect(user.profile.notifications.count).to eq 5
    expect(page).to have_content 'começou a te seguir'
    expect(page).to have_content 'curtiu sua publicação'
    expect(page).to have_content 'comentou em sua publicação'
    expect(page).to have_content 'curtiu seu comentário'
    expect(page).to have_content 'Você recebeu um convite'
  end

  it 'deve estar logado' do
    visit notifications_path

    expect(page).to have_current_path new_user_session_path
  end

  it 'e não tem notificações' do
    user = create(:user)

    login_as user

    visit notifications_path

    expect(page).to have_content 'Nenhuma notificação'
    expect(Notification.count).to eq 0
  end
end
