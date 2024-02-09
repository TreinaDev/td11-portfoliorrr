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

    RequestInvitationJob.perform_now(invitation_request:)
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
  
  pending 'altera a solicitação de convite para error caso receba um aviso de erro do Cola?Bora!'
  pending 'altera a solicitação de convite para aborted se receber pela quinta vez um erro da API do Cola?Bora!'
end















[
 {"job_class"=>"RequestInvitationJob",
  "job_id"=>"950bf48c-49ae-4a26-831b-3554361a5c05",
  "provider_job_id"=>nil,
  "queue_name"=>"default",
  "priority"=>nil,
  "arguments"=>
   [{"invitation_request"=>{"_aj_globalid"=>"gid://portfoliorrr/InvitationRequest/1"},
     "_aj_ruby2_keywords"=>["invitation_request"]}],
  "executions"=>0,
  "exception_executions"=>{},
  "locale"=>"pt-BR",
  "timezone"=>"Brasilia",
  "enqueued_at"=>"2024-02-09T21:34:02.092006073Z",
  "scheduled_at"=>nil,
  
  :job=>RequestInvitationJob,
  :args=>
   [{"invitation_request"=>{"_aj_globalid"=>"gid://portfoliorrr/InvitationRequest/1"},
     "_aj_ruby2_keywords"=>["invitation_request"]}],
  :queue=>"default",
  :priority=>nil},
  
 {"job_class"=>"RequestInvitationJob",
  "job_id"=>"e7078bee-51c3-4b9e-94e1-9db0468a3927",
  "provider_job_id"=>nil,
  "queue_name"=>"default",
  "priority"=>nil,
  "arguments"=>
   [{"invitation_request"=>{"_aj_globalid"=>"gid://portfoliorrr/InvitationRequest/1"},
     "_aj_ruby2_keywords"=>["invitation_request"]}],
  "executions"=>0,
  "exception_executions"=>{},
  "locale"=>"pt-BR",
  "timezone"=>"Brasilia",
  "enqueued_at"=>"2024-02-09T21:34:02.093293768Z",
  "scheduled_at"=>"2024-02-09T22:34:02.093161504Z",
  :job=>RequestInvitationJob,
  :args=>
   [{"invitation_request"=>{"_aj_globalid"=>"gid://portfoliorrr/InvitationRequest/1"},
     "_aj_ruby2_keywords"=>["invitation_request"]}],
  :queue=>"default",
  :priority=>nil,
  :at=>1707518042.0931616}]