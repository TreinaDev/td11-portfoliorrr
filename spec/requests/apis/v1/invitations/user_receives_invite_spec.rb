require 'rails_helper'

describe 'API convites' do
  context 'POST /api/v1/invitations' do
    it 'com sucesso' do
      user_profile = create(:profile)

      mail = double('mail', deliver_later: true)
      mailer_double = double('InvitationsMailer', received_invitation: mail)
      allow(InvitationsMailer).to receive(:with).and_return(mailer_double)
      allow(mailer_double).to receive(:received_invitation).and_return(mail)

      post '/api/v1/invitations', params: {
        invitation: {
          profile_id: user_profile.id,
          project_title: 'Projeto Cola?Bora!',
          project_description: 'Projeto Legal',
          project_category: 'Tecnologia',
          colabora_invitation_id: 1,
          message: 'Venha participar do meu projeto!',
          expiration_date: 1.week.from_now.to_date
        }
      }

      expect(mail).to have_received(:deliver_later)
      expect(response).to have_http_status(201)
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['data']['invitation_id']).to eq 1
      expect(Invitation.count).to eq 1
      expect(user_profile.invitations.first.colabora_invitation_id).to eq 1
    end

    it 'enfileira job para validar solicitação pendente e alterar para aceita' do
      user = create(:user)
      create(:invitation_request, status: :pending, profile: user.profile, project_id: 1)
      colabora_invitation_json = [{
        invitation_id: 1,
        expiration_date: 3.days.from_now.to_date,
        project_id: 1,
        project_title: 'Meu primeiro projeto',
        message: 'Venha fazer parte'
      }].to_json

      accept_invitation_request_job_spy = spy(AcceptInvitationRequestJob)
      stub_const('AcceptInvitationRequestJob', accept_invitation_request_job_spy)

      fake_response = double('faraday_response', status: 200, body: colabora_invitation_json)
      allow(Faraday).to receive(:get).with("http://localhost:3000/api/v1/invitations?profile_id=#{user.id}")
                    .and_return(fake_response)

      post '/api/v1/invitations', params: {
        invitation: {
          profile_id: user.id,
          project_title: 'Projeto Cola?Bora!',
          project_description: 'Projeto Legal',
          project_category: 'Tecnologia',
          colabora_invitation_id: 1,
          message: 'Venha participar do meu projeto!',
          expiration_date: 1.week.from_now.to_date
        }
      }

      expect(accept_invitation_request_job_spy).to have_receive(:perform_later)
    end

    context 'com parâmetros inválidos' do
      it 'parametros em branco' do
        post '/api/v1/invitations'

        expect(response).to have_http_status(400)
        expect(response.content_type).to include 'application/json'
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq 'Houve um erro ao processar sua solicitação.'
        expect(Invitation.count).to eq 0
      end

      it 'com usuário inexistente' do
        post '/api/v1/invitations', params: {
          invitation: {
            profile_id: 3,
            project_title: 'Projeto Cola?Bora!',
            project_description: 'Projeto Legal',
            project_category: 'Tecnologia',
            colabora_invitation_id: 1,
            message: 'Venha participar do meu projeto!',
            expiration_date: 1.week.from_now.to_date
          }
        }

        expect(response).to have_http_status(400)
        expect(response.content_type).to include 'application/json'
        expect(Invitation.count).to eq 0
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq 'Houve um erro ao processar sua solicitação.'
      end
    end
  end
end
