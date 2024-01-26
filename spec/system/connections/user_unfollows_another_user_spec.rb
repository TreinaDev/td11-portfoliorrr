require 'rails_helper'

describe 'Usuário deixa de seguir outro usuário' do
  it 'com sucesso' do
    followed = create(:user, full_name: 'Eliseu Ramos')
    follower = create(:user, full_name: 'Gabriel Manika', email: 'emailaleatorio@email.com',
                             citizen_id_number: '24432047070')
    Connection.create!(followed_profile: followed.profile, follower: follower.profile)

    login_as follower
    visit profile_path(followed.profile)
    click_on 'Deixar de Seguir'

    follower_relationship = Connection.last
    expect(current_path).to eq profile_path(followed.profile)
    expect(follower_relationship).to be_inactive
    expect(page).to have_content("Você deixou de seguir #{followed.full_name}")
    expect(page).to have_button('Seguir', exact: true)
    expect(page).not_to have_button('Deixar de Seguir', exact: true)
  end

  it 'e falha caso ele já não esteja o seguindo' do
    followed = create(:user, full_name: 'Eliseu Ramos')
    follower = create(:user, full_name: 'Gabriel Manika', email: 'emailaleatorio@email.com',
                             citizen_id_number: '24432047070')
    connection = Connection.create!(followed_profile: followed.profile, follower: follower.profile, status: 'active')

    login_as follower
    visit profile_path(followed.profile)
    connection.inactive!
    click_on 'Deixar de Seguir'

    expect(page).to have_content 'Você ainda não segue este usuário'
    expect(page).to have_button('Seguir', exact: true)
    expect(page).not_to have_button('Deixar de Seguir', exact: true)
  end
end
