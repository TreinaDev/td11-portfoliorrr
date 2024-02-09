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
end
