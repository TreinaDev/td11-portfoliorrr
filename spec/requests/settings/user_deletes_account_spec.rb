require 'rails_helper'

describe 'Usuário deleta conta' do
  it 'com sucesso' do
    user = create(:user)
    other_user = create(:user)
    create(:post, user:)
    user.personal_info.update(city: 'São Paulo')
    user.education_infos.update(institution: 'Campus Code')
    user.professional_infos.update(company: 'Rebase')
    Connection.create(follower: user.profile, followed_profile: other_user.profile)
    Connection.create(follower: other_user.profile, followed_profile: user.profile)

    login_as user
    delete(delete_account_path)

    expect(User.all.count).to eq 1
    expect(Profile.all.count).to eq 1
    expect(Post.all.count).to eq 0
    expect(Connection.all.count).to eq 0
    expect(PersonalInfo.all.count).to eq 1
    expect(EducationInfo.all.count).to eq 0
    expect(ProfessionalInfo.all.count).to eq 0
    expect(flash[:notice]).to eq 'Conta excluída com sucesso'
  end
end
