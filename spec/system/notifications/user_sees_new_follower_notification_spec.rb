require 'rails_helper'

describe 'Usuário vê notificação de novo seguidor' do
  it 'com sucesso' do
    follower = create(:user, full_name: 'Paulo')
    followed = create(:user, full_name: 'Ana')
    Connection.create!(followed_profile: followed.profile, follower: follower.profile)

    login_as followed
    visit notifications_path

    expect(page).to have_current_path notifications_path
    expect(page).to have_content 'Paulo começou a te seguir'
  end

  it 'ao clicar na notificação redireciona para o perfil do seguidor' do
    follower = create(:user, full_name: 'Paulo')
    followed = create(:user, full_name: 'Ana')
    Connection.create!(followed_profile: followed.profile, follower: follower.profile)

    login_as followed
    visit notifications_path
    click_on 'Paulo começou a te seguir'

    expect(page).to have_current_path profile_path(follower)
    expect(Notification.last).to be_clicked
  end
end
