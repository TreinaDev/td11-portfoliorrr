require 'rails_helper'

describe 'Usuário vê perfil de outro usuário' do
  it 'e vê o número de seguidores' do
    first_follower = create(:user)
    second_follower = create(:user, full_name: 'Gabriel Manika', email: 'emailaleatorio@email.com',
                                    citizen_id_number: '24432047070')
    third_follower = create(:user, full_name: 'Eliseu Ramos', email: 'eliseu@email.com',
                                   citizen_id_number: '60599066059')
    followed = create(:user, full_name: 'Rosemilson Barbosa', email: 'rosemilson@email.com',
                             citizen_id_number: '03971055095')
    Follower.create!(follower: first_follower.profile, followed_profile: followed.profile, status: 'inactive')
    Follower.create!(follower: second_follower.profile, followed_profile: followed.profile,
                     status: 'active')
    Follower.create!(follower: third_follower.profile, followed_profile: followed.profile,
                     status: 'active')

    visit profile_path(followed.profile)

    within '#followers-count' do
      expect(page).to have_link '2 Seguidores', href: profile_followers_path(followed.profile)
    end
  end

  it 'e vê o número de perfis seguidos por ele' do
    first_followed = create(:user)
    second_followed = create(:user, full_name: 'Gabriel Manika', email: 'emailaleatorio@email.com',
                                    citizen_id_number: '24432047070')
    third_followed = create(:user, full_name: 'Eliseu Ramos', email: 'eliseu@email.com',
                                   citizen_id_number: '60599066059')
    follower = create(:user, full_name: 'Rosemilson Barbosa', email: 'rosemilson@email.com',
                             citizen_id_number: '03971055095')

    Follower.create!(follower: follower.profile, followed_profile: first_followed.profile, status: 'inactive')
    Follower.create!(follower: follower.profile, followed_profile: second_followed.profile, status: 'active')
    Follower.create!(follower: follower.profile, followed_profile: third_followed.profile, status: 'active')

    visit profile_path(follower.profile)

    within '#following-count' do
      expect(page).to have_link '2 Seguindo', href: profile_following_path(follower.profile)
    end
  end
end
