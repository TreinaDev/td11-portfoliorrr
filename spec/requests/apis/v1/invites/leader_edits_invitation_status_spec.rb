require 'rails_helper'

describe 'Endpoint edita status do pedido' do
  context 'PATCH /api/v1/invitations/:id' do
    it 'mudar status do convite com sucesso' do
      profile = create(:profile)
      invite = Invitation.create! profile:, project_title: 'Projeto Cola?Bora!',
                                  project_description: 'Projeto Legal', project_category: 'Tecnologia',
                                  colabora_invitation_id: 1, message: 'Venha participar do meu projeto!',
                                  expiration_date: 1.week.from_now.to_date, status: 'pending'

      patch "/api/v1/invitations/#{invite.id}", params: {
        data: {
          status: 'accepted'
        }
      }

      expect(response).to have_http_status(:no_content)
      expect(Invitation.last.status).to eq 'accepted'
    end

    context 'e não consegue mudar status' do
      it 'id do convite inválido' do
        patch '/api/v1/invitations/999', params: {
          data: {
            status: 'accepted'
          }
        }

        expect(response).to have_http_status(:not_found)
        expect(response.content_type).to include 'application/json'
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to include 'Não encontrado'
      end

      it 'status inválido' do
        profile = create(:profile)
        invite = Invitation.create! profile:, project_title: 'Projeto Cola?Bora!',
                                    project_description: 'Projeto Legal', project_category: 'Tecnologia',
                                    colabora_invitation_id: 1, message: 'Venha participar do meu projeto!',
                                    expiration_date: 1.week.from_now.to_date, status: 'pending'

        patch "/api/v1/invitations/#{invite.id}", params: {
          data: {
            status: 'XXXXXXXXXXX'
          }
        }

        expect(response).to have_http_status(:bad_request)
        expect(Invitation.last.status).to eq 'pending'
      end
    end
  end
end
