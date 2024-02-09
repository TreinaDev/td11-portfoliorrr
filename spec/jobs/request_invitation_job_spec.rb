require 'rails_helper'

RSpec.describe RequestInvitationJob, type: :job do
  it 'envia uma requisição à nossa API para iniciar a criação de um proposal no Cola?Bora!' do
    invitation_request = create(:invitation_request)
    invitation_request_params = { data: { proposal: { invitation_request_id: invitation_request.id,
                                                      project_id: invitation_request.project_id,
                                                      profile_id: invitation_request.profile.id,
                                                      email: invitation_request.profile.email,
                                                      message: invitation_request.message } } }.as_json

    json_proposal_response = File.read(Rails.root.join('./spec/support/json/proposal_201.json'))
    fake_portfoliorrr_response = double('faraday_response', status: :ok, body: json_proposal_response)
    portfoliorrr_api_connection = double('Faraday::Conection', get: fake_portfoliorrr_response)

    allow(Faraday).to receive(:new)
                  .with(url: 'http://localhost:4000', params: invitation_request_params)
      .and_return(portfoliorrr_api_connection)
    allow(portfoliorrr_api_connection)
      .to receive(:get)
      .with('/api/v1/projects/request_invitation')
      .and_return(fake_portfoliorrr_response)

    response = RequestInvitationJob.perform_now(invitation_request:)

    expect(portfoliorrr_api_connection).to have_received(:get).with('/api/v1/projects/request_invitation')
    json_response = JSON.parse(response.body)
    expect(json_response['data']['proposal_id']).to eq 1
  end

  pending 'altera a solicitação de convite para pending caso receba uma confirmação de sucesso do Cola?Bora!'
  pending 'altera a solicitação de convite para error caso receba um aviso de erro do Cola?Bora!'
  pending 'enfileira um novo job caso receba um aviso de erro no servidor do Cola?Bora!'
  pending 'altera a solicitação de convite para aborted se receber pela quinta vez um erro da API do Cola?Bora!'
end
