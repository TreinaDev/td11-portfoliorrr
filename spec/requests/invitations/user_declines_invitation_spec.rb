require 'rails_helper'

describe 'Usuário recusa convite' do
  it 'e deve ser o dono do convite' do
    user = create(:user)
    other_user = create(:user)
    invitation = create(:invitation, profile: user.profile)
    login_as other_user

    patch decline_invitation_path(invitation)

    expect(response).to redirect_to(root_path)
    expect(flash[:alert]).to eq 'Você não têm permissão para realizar essa ação.'
    expect(invitation.reload.pending?).to be true
  end

  it 'deve estar logado' do
    invitation = create(:invitation)

    patch decline_invitation_path(invitation)

    expect(response).to redirect_to(new_user_session_path)
    expect(invitation.reload.pending?).to be true
  end

  it 'e tenta cancelar um convite já recusado' do
    user = create(:user)
    invitation = create(:invitation, profile: user.profile, status: :declined)
    login_as user

    patch decline_invitation_path(invitation)

    expect(response).to redirect_to(invitation_path(invitation))
    expect(flash[:notice]).to eq 'Impossível recusar um convite que não esteja pendente'
  end
end
