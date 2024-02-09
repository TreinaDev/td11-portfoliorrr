require 'rails_helper'

describe 'Usuário vê notificação de comentário' do
  it 'com sucesso' do
    user = create(:user)
    post = create(:post, user:)
    other_user = create(:user)
    comment = create(:comment, post:, user: other_user)

    login_as user
    visit notifications_path

    expect(Notification.count).to eq 1
    expect(page).to have_current_path notifications_path
    expect(page).to have_content 'comentou em sua publicação'
    expect(page).to have_link comment.user.profile.full_name, href: profile_path(comment.user.profile)
  end

  it 'e não vê notificação de seu comentário' do
    user = create(:user)
    post = create(:post, user:)
    comment = create(:comment, post:, user:)

    login_as user
    visit notifications_path

    expect(Notification.count).to eq 0
    expect(page).not_to have_content 'comentou em sua publicação'
    expect(page).not_to have_link comment.user.profile.full_name, href: profile_path(comment.user.profile)
  end
end