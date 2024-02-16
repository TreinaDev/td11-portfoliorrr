require 'rails_helper'

describe 'Usuário vê lista de usuários seguidos' do
  context 'de outro usuário' do
    it 'a partir do perfil' do
      first_followed = create(:user)
      second_followed = create(:user, full_name: 'Gabriel Manika')
      third_followed = create(:user, full_name: 'Eliseu Ramos')
      fourth_followed = create(:user, full_name: 'Danilo Martins')
      follower = create(:user, full_name: 'Rosemilson Barbosa')

      second_followed.profile.update(work_status: 'open_to_work')
      third_followed.profile.update(work_status: 'unavailable')
      create(:professional_info,
             company: 'Rebase',
             position: 'Dev Senior',
             profile: fourth_followed.profile,
             current_job: true)

      Connection.create!(follower: follower.profile, followed_profile: first_followed.profile, status: 'inactive')
      Connection.create!(follower: follower.profile, followed_profile: second_followed.profile, status: 'active')
      Connection.create!(follower: follower.profile, followed_profile: third_followed.profile, status: 'active')
      Connection.create!(follower: follower.profile, followed_profile: fourth_followed.profile, status: 'active')

      login_as first_followed
      visit profile_path(follower.profile)
      click_on '3 Seguindo'

      expect(page).to have_current_path profile_following_path(follower.profile)
      expect(page).to have_content follower.full_name
      expect(page).to have_content 'Seguindo 3 usuários'
      expect(page).not_to have_link first_followed.full_name

      expect(page).to have_link second_followed.full_name, href: profile_path(second_followed.profile)

      expect(page).to have_link third_followed.full_name, href: profile_path(third_followed.profile)

      expect(page).to have_link fourth_followed.full_name, href: profile_path(fourth_followed.profile)
    end

    it 'e deve estar logado' do
      user = create(:user, full_name: 'Rosemilson Barbosa', email: 'rosemilson@email.com',
                           citizen_id_number: '03971055095')

      visit profile_following_path(user.profile)

      expect(page).to have_current_path new_user_session_path
    end
  end
end
