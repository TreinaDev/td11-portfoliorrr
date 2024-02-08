require 'rails_helper'

describe 'Usuário desativa perfil' do
  it 'com sucesso' do
    profile = create(:profile)
    user = profile.user
    other_user = create(:user)
    post = create(:post, user:)
    followed = Connection.create(follower: profile, followed_profile: other_user.profile)
    follower = Connection.create(follower: other_user.profile, followed_profile: profile)

    login_as user
    patch(deactivate_profile_path)

    expect(profile.reload.status).to eq 'inactive'
    expect(post.reload.status).to eq 'archived'
    expect(Connection.active.count).to eq 0
  end
end
