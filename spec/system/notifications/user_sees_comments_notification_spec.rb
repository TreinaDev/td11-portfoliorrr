require 'rails_helper'

describe 'Usuário vê notificação de comentário' do
  it 'ao comentarem na sua publicação' do
    user = create(:user)
    post = create(:post, user:)
    other_user = create(:user)
    create(:comment, post:, user: other_user)

    login_as user
    visit notifications_path

    expect(Notification.count).to eq 1
    expect(page).to have_current_path notifications_path
    expect(page).to have_content "#{other_user.full_name} comentou em sua publicação: #{post.title}"
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

  it 'ao curtirem seu comentário' do
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
    expect(page).to have_content "#{like.user.full_name} curtiu seu comentário"
    expect(Notification.last).to be_seen
  end

  it 'e não recebe ao curtir seu próprio comentário' do
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

  context 'ao clicar na notificação' do
    it 'de comentário é redirecionado para a página do post' do
      user = create(:user)
      post = create(:post, user:)
      comment = create(:comment, post:)

      login_as user
      visit notifications_path
      click_on comment.user.full_name

      expect(page).to have_current_path post_path(post)
      expect(page).to have_content post.title
      expect(page).to have_content comment.message
      expect(Notification.last).to be_clicked
    end

    it 'de curtida é redirecionado para a página do post' do
      user = create(:user)
      post = create(:post)
      comment = create(:comment, post:, user:)
      like = create(:like, likeable: comment)

      login_as user
      visit notifications_path
      click_on like.user.full_name

      expect(page).to have_current_path post_path(post)
      expect(page).to have_content post.title
      expect(page).to have_content comment.message
      expect(Notification.last).to be_clicked
    end
  end
end
