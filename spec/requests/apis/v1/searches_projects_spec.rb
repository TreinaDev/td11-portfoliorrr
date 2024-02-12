require 'rails_helper'

describe 'Usuário tenta pesquisar projetos Cola?Bora!' do
  it 'mas ocorre erro na conexão' do
    user = create(:user)
    allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/projects').and_raise(Faraday::ConnectionFailed)

    login_as user
    get 'http://localhost:3000/api/v1/projects'

    expect(response).to have_http_status :service_unavailable
    json_response = JSON.parse(response.body)
    expect(json_response['error']).to eq 'Recurso não disponível'
  end

  it 'e ocorre erro interno do servidor' do
    user = create(:user)
    fake_response = double('faraday_response', status: 500, body: { 'error': 'Erro interno de servidor.' }.to_json)
    allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/projects').and_return(fake_response)

    login_as user
    get 'http://localhost:3000/api/v1/projects'
    json_response = JSON.parse(response.body)

    expect(response).to have_http_status :internal_server_error
    expect(json_response['error']).to eq 'Erro interno de servidor.'
  end
end
