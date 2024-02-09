require 'rails_helper'

describe 'Nova publicação envia notificação para seguidores' do
  it 'com sucesso' do
    follower = create(:user, full_name: 'Paulo')
    followed = create(:user, full_name: 'Ana')
    Connection.create!(followed_profile: followed.profile, follower: follower.profile)
    post = create(:post, user: followed)

    login_as follower
    visit root_path
    click_button class: 'dropdown-toggle'
    within 'nav' do
      click_on 'Notificações'
    end

    expect(page).to have_current_path notifications_path
    expect(page).to have_content "#{followed.full_name} fez uma publicação"
    expect(page).to have_link 'publicação', href: post_path(post)
  end

  it 'e nao envia para quem nao segue' do
    follower = create(:user, full_name: 'Paulo')
    followed = create(:user, full_name: 'Ana')
    Connection.create!(followed_profile: followed.profile, follower: follower.profile)
    not_follower = create(:user, full_name: 'João')
    create(:post, user: followed)

    login_as not_follower
    visit root_path
    click_button class: 'dropdown-toggle'
    within 'nav' do
      click_on 'Notificações'
    end

    expect(page).to have_current_path notifications_path
    expect(page).not_to have_content "#{followed.full_name} fez uma publicação"
    expect(not_follower.profile.notifications).to be_empty
    expect(follower.profile.notifications.count).to eq 1
  end
end
