require 'rails_helper'

describe 'Usuário vê lista de seguidores' do
  it 'a partir do perfil' do
    first_follower = create(:user)
    second_follower = create(:user, full_name: 'Gabriel Manika')
    third_follower = create(:user, full_name: 'Eliseu Ramos')
    fourth_follower = create(:user, full_name: 'Danilo Martins')
    followed = create(:user, full_name: 'Rosemilson Barbosa')

    second_follower.profile.update(work_status: 'open_to_work')
    third_follower.profile.update(work_status: 'unavailable')
    create(:professional_info,
           company: 'Rebase',
           position: 'Dev Senior',
           profile: fourth_follower.profile,
           current_job: true)

    Connection.create!(follower: first_follower.profile, followed_profile: followed.profile, status: 'inactive')
    Connection.create!(follower: second_follower.profile, followed_profile: followed.profile, status: 'active')
    Connection.create!(follower: third_follower.profile, followed_profile: followed.profile, status: 'active')
    Connection.create!(follower: fourth_follower.profile, followed_profile: followed.profile, status: 'active')

    login_as first_follower
    visit profile_path(followed.profile)
    click_on '3 Seguidores'

    expect(page).to have_current_path profile_connections_path(followed.profile)
    expect(page).to have_content followed.full_name
    expect(page).to have_content 'Seguido por 3 usuários'

    expect(page).not_to have_link first_follower.full_name

    expect(page).to have_link second_follower.full_name, href: profile_path(second_follower.profile)
    expect(page).to have_content 'Disponível Para Trabalho'

    expect(page).to have_link third_follower.full_name, href: profile_path(third_follower.profile)
    expect(page).to have_content 'Indisponível Para Trabalho'

    expect(page).to have_link fourth_follower.full_name, href: profile_path(fourth_follower.profile)
    expect(page).to have_content 'Dev Senior | Rebase'
  end

  it 'e deve estar logado' do
    user = create(:user, full_name: 'Rosemilson Barbosa', email: 'rosemilson@email.com',
                         citizen_id_number: '03971055095')

    visit profile_connections_path(user.profile)

    expect(page).to have_current_path new_user_session_path
  end
end
