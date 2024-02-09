require 'rails_helper'

describe 'Usuário desativa perfil' do
  it 'com sucesso' do
    profile = create(:profile)
    user = profile.user
    other_user = create(:user)
    post1 = create(:post, user:)
    post2 = create(:post, user:, status: 'draft')
    post3 = create(:post, user:, status: 'archived')
    Connection.create(follower: profile, followed_profile: other_user.profile)
    Connection.create(follower: other_user.profile, followed_profile: profile)

    login_as user
    patch(deactivate_profile_path)

    expect(profile.reload.status).to eq 'inactive'
    expect(profile.reload.full_name).to eq 'Perfil Desativado'
    expect(Post.archived.count).to eq 3
    expect(post1.reload.old_status).to eq 'published'
    expect(post2.reload.old_status).to eq 'draft'
    expect(post3.reload.old_status).to eq 'archived'
    expect(Connection.active.count).to eq 0
  end
end
