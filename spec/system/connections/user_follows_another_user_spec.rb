require 'rails_helper'

describe 'Usuário segue outro usuário' do
  it 'com sucesso' do
    followed = create(:user, full_name: 'Eliseu Ramos')
    follower = create(:user, full_name: 'Gabriel Manika', email: 'emailaleatorio@email.com',
                             citizen_id_number: '24432047070')
    mail = double('mail', deliver_later: true)
    mailer_double = double('NotificationsMailer', notify_follow: mail)
    allow(ConnectionsMailer).to receive(:with).and_return(mailer_double)
    allow(mailer_double).to receive(:notify_follow).and_return(mail)

    login_as follower
    visit profile_path(followed)
    click_on 'Seguir'

    expect(mail).to have_received(:deliver_later)

    expect(Connection.count).to eq 1
    expect(page).to have_current_path profile_path(followed)
    expect(page).to have_content('Agora você está seguindo Eliseu Ramos')
    expect(page).not_to have_button('Seguir', exact: true)
    expect(page).to have_button('Deixar de Seguir', exact: true)
  end

  it 'e deve estar logado' do
    followed = create(:user, full_name: 'Eliseu Ramos')

    visit profile_path(followed.profile)

    expect(page).to have_current_path new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'que havia deixado de seguir' do
    followed = create(:user, full_name: 'Eliseu Ramos')
    follower = create(:user, full_name: 'Gabriel Manika', email: 'emailaleatorio@email.com',
                             citizen_id_number: '24432047070')
    Connection.create!(followed_profile: followed.profile, follower: follower.profile, status: 'inactive')

    login_as follower
    visit profile_path(followed.profile)
    click_on 'Seguir'

    follower_relationship = Connection.last
    expect(page).to have_current_path profile_path(followed.profile)
    expect(follower_relationship).to be_active
    expect(page).to have_content('Agora você está seguindo Eliseu Ramos')
    expect(page).to have_button('Deixar de Seguir', exact: true)
    expect(page).not_to have_button('Seguir', exact: true)
  end

  it 'e não pode seguir ele mesmo' do
    follower = create(:user, full_name: 'Gabriel Manika', email: 'emailaleatorio@email.com',
                             citizen_id_number: '24432047070')

    login_as follower
    visit profile_path(follower.profile)

    expect(page).not_to have_button('Seguir', exact: true)
    expect(page).not_to have_button('Deixar de Seguir', exact: true)
  end

  it 'e não pode seguir o mesmo usuário novamente' do
    followed = create(:user, full_name: 'Eliseu Ramos')
    follower = create(:user, full_name: 'Gabriel Manika', email: 'emailaleatorio@email.com',
                             citizen_id_number: '24432047070')

    login_as follower
    visit profile_path(followed.profile)
    Connection.create(follower: follower.profile, followed_profile: followed.profile)
    click_on 'Seguir'

    expect(page).to have_content 'Você já está seguindo este usuário'
    expect(page).not_to have_button('Seguir', exact: true)
    expect(page).to have_button('Deixar de Seguir', exact: true)
  end

  it 'e não pode voltar a seguir um usuário que já está seguindo' do
    followed = create(:user, full_name: 'Eliseu Ramos')
    follower = create(:user, full_name: 'Gabriel Manika', email: 'emailaleatorio@email.com',
                             citizen_id_number: '24432047070')
    connection = Connection.create(follower: follower.profile, followed_profile: followed.profile, status: 'inactive')

    login_as follower
    visit profile_path(followed.profile)
    connection.active!
    click_on 'Seguir'

    expect(page).to have_content 'Você já está seguindo este usuário'
    expect(page).not_to have_button('Seguir', exact: true)
    expect(page).to have_button('Deixar de Seguir', exact: true)
  end
end
