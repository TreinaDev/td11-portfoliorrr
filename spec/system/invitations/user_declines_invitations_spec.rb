require 'rails_helper'

describe 'Usuário recusa convite' do
  it 'com sucesso' do
    user = create(:user)
    invitation = create(:invitation, profile: user.profile)
    login_as invitation.profile.user

    visit invitations_path
    click_on invitation.project_title
    click_on 'Recusar'

    expect(page).to have_content 'Convite recusado'
    expect(page).to have_content 'Recusado'
    expect(page).not_to have_content 'Recusar'
  end

  it 'e deve ser o dono do convite' do
    user = create(:user)
    other_user = create(:user)
    invitation = create(:invitation, profile: user.profile)

    login_as other_user

    visit invitation_path(invitation)

    expect(page).to have_current_path(root_path)
    expect(page).to have_content 'Você não têm permissão para realizar essa ação.'
    expect(invitation.reload.pending?).to be true
  end
end