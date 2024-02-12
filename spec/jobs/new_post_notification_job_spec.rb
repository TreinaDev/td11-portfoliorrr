require 'rails_helper'

RSpec.describe NewPostNotificationJob, type: :job do
  include ActiveJob::TestHelper

  it 'Seguidores recebem notificação de novo post com sucesso' do
    follower = create(:user, full_name: 'Paulo')
    another_follower = create(:user, full_name: 'Pedro')
    not_follower = create(:user, full_name: 'João')
    followed = create(:user, full_name: 'Ana')
    Connection.create!(followed_profile: followed.profile, follower: follower.profile)
    Connection.create!(followed_profile: followed.profile, follower: another_follower.profile)
    post = build(:post, user: followed)

    NewPostNotificationJob.perform_now(post)

    expect(follower.profile.notifications.count).to eq 1
    expect(follower.profile.notifications.first.notifiable).to be_a(Post)
    expect(another_follower.profile.notifications.count).to eq 1
    expect(another_follower.profile.notifications.first.notifiable).to be_a(Post)
    expect(not_follower.profile.notifications).to be_empty
  end
end
