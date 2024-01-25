require 'rails_helper'

describe 'Usuário vê lista de seguidores' do
  it 'a partir do perfil' do
    first_follower = create(:user)
    second_follower = create(:user, full_name: 'Gabriel Manika', email: 'emailaleatorio@email.com',
                                    citizen_id_number: '24432047070')
    third_follower = create(:user, full_name: 'Eliseu Ramos', email: 'eliseu@email.com',
                                   citizen_id_number: '60599066059')
    followed = create(:user, full_name: 'Rosemilson Barbosa', email: 'rosemilson@email.com',
                             citizen_id_number: '03971055095')
    Connection.create!(follower: first_follower.profile, followed_profile: followed.profile, status: 'inactive')
    Connection.create!(follower: second_follower.profile, followed_profile: followed.profile, status: 'active')
    Connection.create!(follower: third_follower.profile, followed_profile: followed.profile, status: 'active')

    login_as first_follower
    visit profile_path(followed.profile)
    click_on '2 Seguidores'

    expect(current_path).to eq profile_connections_path(followed.profile)
    expect(page).to have_content "Usuários que seguem #{followed.full_name}"
    expect(page).not_to have_link first_follower.full_name
    expect(page).to have_link third_follower.full_name, href: profile_path(third_follower.profile)
    expect(page).to have_link second_follower.full_name, href: profile_path(second_follower.profile)
  end

  it 'e deve estar logado' do
    user = create(:user, full_name: 'Rosemilson Barbosa', email: 'rosemilson@email.com',
                         citizen_id_number: '03971055095')

    visit profile_connections_path(user.profile)

    expect(current_path).to eq new_user_session_path
  end
end
