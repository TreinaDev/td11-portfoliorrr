require 'rails_helper'

describe 'Solicitação de convite é aceita' do
  it 'com sucesso' do
    user = create(:user)

    invitation_request_one = create(:invitation_request, profile: user.profile,
                                                         project_id: 1, status: :pending)
    invitation_request_two = create(:invitation_request, profile: user.profile,
                                                         project_id: 2, status: :pending)

    json_data = File.read(Rails.root.join('./spec/support/json/projects.json'))
    fake_projects_response = double('faraday_response', success?: true, body: json_data)
    allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/projects').and_return(fake_projects_response)

    colabora_invitation_json = [{
      invitation_id: 1,
      expiration_date: 3.days.from_now.to_date,
      project_id: 1,
      project_title: 'Meu primeiro projeto',
      message: 'Venha fazer parte'
    }].to_json

    fake_invitation_list_response = double('faraday_response', status: 200, body: colabora_invitation_json)
    allow(Faraday).to receive_message_chain(:new, :get).with("http://localhost:3000/api/v1/invitations?profile_id=#{user.profile.id}")
                  .and_return(fake_invitation_list_response)

    invitation = build(:invitation, profile: user.profile, colabora_invitation_id: 1)

    AcceptInvitationRequestJob.perform_now(
      profile_id: user.profile.id,
      colabora_invitation_id: invitation.colabora_invitation_id
    )

    login_as user
    visit invitation_requests_path

    expect(invitation_request_one.reload).to be_accepted
    expect(invitation_request_two.reload).to be_pending

    within "#request_#{invitation_request_one.id}" do
      expect(page).to have_content 'Aceita'
    end

    within "#request_#{invitation_request_two.id}" do
      expect(page).to have_content 'Pendente'
    end
  end
end
