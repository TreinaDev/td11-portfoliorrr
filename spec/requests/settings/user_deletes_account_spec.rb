require 'rails_helper'

describe 'Usuário deleta conta' do
  it 'com sucesso' do
    user = create(:user)
    user.personal_info.update!(city: 'São Paulo')
    user.education_infos.update!(institution: 'Campus Code')
    user.professional_infos.update!(company: 'Rebase')
    create(:invitation, profile: user.profile)
    create(:invitation_request, profile: user.profile)
    other_user = create(:user)
    Connection.create(follower: user.profile, followed_profile: other_user.profile)
    Connection.create(follower: other_user.profile, followed_profile: user.profile)
    post = create(:post, user:)
    post.comments.create!(message: 'Novo comentário', user:)

    login_as user
    delete(delete_account_path)

    expect(User.find_by(id: user.id)).to be_nil
    expect(Profile.find_by(user_id: user.id)).to be_nil
    expect(PersonalInfo.find_by(profile_id: user.profile.id)).to be_nil
    expect(EducationInfo.all.count).to eq 0
    expect(ProfessionalInfo.all.count).to eq 0
    expect(Invitation.all.count).to eq 0
    expect(InvitationRequest.all.count).to eq 0
    expect(Connection.all.count).to eq 0
    deleted_user = User.find_by(full_name: 'Conta Excluída')
    expect(deleted_user.comments.last.message).to eq 'Comentário Removido'
    expect(flash[:notice]).to eq 'Conta excluída com sucesso'
  end
end
