require 'rails_helper'

describe 'Solicitação de convite tem status atualizado para "aceita"' do
  it 'quando recebe convite para o mesmo projeto' do
    user = create(:user)

    invitation_request_one = create(:invitation_request, profile: user.profile,
                                                         project_id: 1, status: :pending)
    invitation_request_two = create(:invitation_request, profile: user.profile,
                                                         project_id: 2, status: :pending)

    json_data = File.read(Rails.root.join('./spec/support/json/projects.json'))
    fake_projects_response = double('faraday_response', success?: true, body: json_data)
    allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/projects').and_return(fake_projects_response)

    create(:invitation, profile: user.profile, project_id: 1,
                        project_title: 'Meu projeto', project_description: 'Projeto legal',
                        project_category: 'Animação', colabora_invitation_id: 3,
                        message: 'Venha fazer parte', expiration_date: 3.days.from_now.to_date)

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
