require 'rails_helper'

describe 'Usuário vê notificações de convite' do
  it 'com sucesso' do
    user = create(:user)
    invitation = create(:invitation, profile: user.profile, created_at: 1.day.ago)

    login_as user
    visit notifications_path

    expect(page).to have_current_path notifications_path
    expect(page).to have_content "Você recebeu um convite para #{invitation.project_title} há 1 dia"
    expect(page).to have_link invitation.project_title, href: invitation_path(invitation)
  end

  it 'e não vê convites de outros usuários' do
    user = create(:user)
    invitation = create(:invitation, profile: user.profile)
    other_user = create(:user)
    other_user_invitation = create(:invitation,
                                   profile: other_user.profile,
                                   project_title: 'Projeto do outro usuário')

    login_as user
    visit notifications_path

    expect(page).to have_content "Você recebeu um convite para #{invitation.project_title}"
    expect(page).to_not have_content "Você recebeu um convite para #{other_user_invitation.project_title}"
  end

  it 'ao clicar na notificação é redirecionado para a página de convites' do
    user = create(:user)
    invitation = create(:invitation, profile: user.profile)

    login_as user
    visit notifications_path
    click_on invitation.project_title

    expect(page).to have_current_path invitation_path(invitation)
    expect(page).to have_content invitation.project_title
  end
end
