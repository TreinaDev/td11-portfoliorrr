require 'rails_helper'

RSpec.describe RequestInvitationJob, type: :job do
  it 'altera a solicitação de convite para pending caso receba uma confirmação de sucesso do Cola?Bora!' do
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

    perform_enqueued_jobs
    invitation_request.reload

    expect(portfoliorrr_api_connection).to have_received(:get).with('/api/v1/projects/request_invitation')
    expect(invitation_request).to be_pending
  end

  it 'enfileira um novo job caso receba um aviso de erro no servidor do Cola?Bora!' do
    invitation_request = create(:invitation_request)
    invitation_request_params = { data: { proposal: { invitation_request_id: invitation_request.id,
                                                      project_id: invitation_request.project_id,
                                                      profile_id: invitation_request.profile.id,
                                                      email: invitation_request.profile.email,
                                                      message: invitation_request.message } } }.as_json

    fake_colabora_response_body = { 'errors': ['Erro interno de servidor.'] }.as_json
    fake_portfoliorrr_response = double('faraday_response', status: :ok, body: fake_colabora_response_body)
    portfoliorrr_api_connection = double('Faraday::Conection', get: fake_portfoliorrr_response)

    allow(Faraday).to receive(:new)
                  .with(url: 'http://localhost:4000', params: invitation_request_params)
      .and_return(portfoliorrr_api_connection)
    allow(portfoliorrr_api_connection)
      .to receive(:get)
      .with('/api/v1/projects/request_invitation')
      .and_return(fake_portfoliorrr_response)

    perform_enqueued_jobs
    invitation_request.reload

    expect(RequestInvitationJob).to have_been_enqueued.once
    expect(invitation_request).to be_processing
  end

  it 'altera a solicitação de convite para error caso receba um aviso de erro do Cola?Bora!' do
    invitation_request = create(:invitation_request)
    invitation_request_params = { data: { proposal: { invitation_request_id: invitation_request.id,
                                                      project_id: invitation_request.project_id,
                                                      profile_id: invitation_request.profile.id,
                                                      email: invitation_request.profile.email,
                                                      message: invitation_request.message } } }.as_json

    fake_colabora_response_body = { 'errors': ['Usuário já faz parte deste projeto'] }.as_json
    fake_portfoliorrr_response = double('faraday_response', status: :ok, body: fake_colabora_response_body)
    portfoliorrr_api_connection = double('Faraday::Conection', get: fake_portfoliorrr_response)

    allow(Faraday).to receive(:new)
                  .with(url: 'http://localhost:4000', params: invitation_request_params)
      .and_return(portfoliorrr_api_connection)
    allow(portfoliorrr_api_connection)
      .to receive(:get)
      .with('/api/v1/projects/request_invitation')
      .and_return(fake_portfoliorrr_response)

    perform_enqueued_jobs
    invitation_request.reload

    expect(RequestInvitationJob).not_to have_been_enqueued
    expect(invitation_request).to be_error
  end

  it 'altera a solicitação de convite para aborted se receber pela quinta vez um erro da API do Cola?Bora!' do
    invitation_request = create(:invitation_request)
    invitation_request_params = { data: { proposal: { invitation_request_id: invitation_request.id,
                                                      project_id: invitation_request.project_id,
                                                      profile_id: invitation_request.profile.id,
                                                      email: invitation_request.profile.email,
                                                      message: invitation_request.message } } }.as_json

    fake_colabora_response_body = { 'errors': ['Erro interno de servidor.'] }.as_json
    fake_portfoliorrr_response = double('faraday_response', status: :ok, body: fake_colabora_response_body)
    portfoliorrr_api_connection = double('Faraday::Conection', get: fake_portfoliorrr_response)

    allow(Faraday).to receive(:new)
                  .with(url: 'http://localhost:4000', params: invitation_request_params)
      .and_return(portfoliorrr_api_connection)
    allow(portfoliorrr_api_connection)
      .to receive(:get)
      .with('/api/v1/projects/request_invitation')
      .and_return(fake_portfoliorrr_response)

    5.times do
      perform_enqueued_jobs
    end
    invitation_request.reload

    expect(RequestInvitationJob).to have_been_performed.exactly(5).times
    expect(RequestInvitationJob).not_to have_been_enqueued
    expect(invitation_request).to be_aborted
  end

  it 'gera uma nova tentativa caso a API do Portfoliorrr esteja fora do ar, sem limite de tentativas' do
    invitation_request = create(:invitation_request)
    invitation_request_params = { data: { proposal: { invitation_request_id: invitation_request.id,
                                                      project_id: invitation_request.project_id,
                                                      profile_id: invitation_request.profile.id,
                                                      email: invitation_request.profile.email,
                                                      message: invitation_request.message } } }.as_json

    fake_response_body = { 'error': 'Houve um erro interno no servidor ao processar sua solicitação.' }.as_json
    fake_portfoliorrr_response = double('faraday_response', status: :internal_server_error, body: fake_response_body)
    portfoliorrr_api_connection = double('Faraday::Conection', get: fake_portfoliorrr_response)

    allow(Faraday).to receive(:new)
                  .with(url: 'http://localhost:4000', params: invitation_request_params)
      .and_return(portfoliorrr_api_connection)
    allow(portfoliorrr_api_connection)
      .to receive(:get)
      .with('/api/v1/projects/request_invitation')
      .and_return(fake_portfoliorrr_response)

    6.times do
      perform_enqueued_jobs
    end
    invitation_request.reload

    expect(RequestInvitationJob).to have_been_performed.exactly(6).times
    expect(RequestInvitationJob).to have_been_enqueued
    expect(invitation_request).to be_processing
  end
end
