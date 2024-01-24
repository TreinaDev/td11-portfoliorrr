require 'rails_helper'

describe 'Qualquer visitante vê lista de usuários seguidos' do
  context 'de outro usuário' do
    it 'a partir do perfil' do
      first_followed = create(:user)
      second_followed = create(:user, full_name: 'Gabriel Manika', email: 'emailaleatorio@email.com',
                                      citizen_id_number: '24432047070')
      third_followed = create(:user, full_name: 'Eliseu Ramos', email: 'eliseu@email.com',
                                     citizen_id_number: '60599066059')
      follower = create(:user, full_name: 'Rosemilson Barbosa', email: 'rosemilson@email.com',
                               citizen_id_number: '03971055095')

      Connection.create!(follower: follower.profile, followed_profile: first_followed.profile, status: 'inactive')
      Connection.create!(follower: follower.profile, followed_profile: second_followed.profile, status: 'active')
      Connection.create!(follower: follower.profile, followed_profile: third_followed.profile, status: 'active')

      visit profile_path(follower.profile)
      click_on '2 Seguindo'

      expect(current_path).to eq profile_following_path(follower.profile)
      expect(page).to have_content "Usuários Seguidos por #{follower.full_name}"
      expect(page).not_to have_link first_followed.full_name
      expect(page).to have_link second_followed.full_name, href: profile_path(second_followed.profile)
      expect(page).to have_link third_followed.full_name, href: profile_path(third_followed.profile)
    end
  end
end

describe 'Qualquer visitante vê lista de seguidores' do
  context 'de outro usuário' do
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

      visit profile_path(followed.profile)
      click_on '2 Seguidores'

      expect(current_path).to eq profile_connections_path(followed.profile)
      expect(page).to have_content "Usuários que seguem #{followed.full_name}"
      expect(page).not_to have_link first_follower.full_name
      expect(page).to have_link third_follower.full_name, href: profile_path(third_follower.profile)
      expect(page).to have_link second_follower.full_name, href: profile_path(second_follower.profile)
    end
  end
end
