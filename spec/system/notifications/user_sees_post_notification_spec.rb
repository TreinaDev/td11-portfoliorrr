require 'rails_helper'

describe 'Nova publicação envia notificação para seguidores' do
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
