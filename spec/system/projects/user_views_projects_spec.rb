require 'rails_helper'
describe 'Usuário visita página de projetos' do
  context 'quando logado' do
    it 'e vê lista de projetos' do
      json_data = File.read(Rails.root.join('./spec/support/json/projects.json'))

      fake_response = double('faraday_response', status: 200, body: json_data)
      allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/projects').and_return(fake_response)

      user = create(:user)

      login_as user

      visit root_path

      click_on 'Projetos'

      expect(page).to have_current_path projects_path
      expect(page).to have_content 'Lista de Projetos'
      expect(page).to have_content 'Título: Projeto Master'
      expect(page).to have_content 'Descrição: Principal projeto criado'
      expect(page).to have_content 'Categoria: Vídeo'
      expect(page).to have_content 'Projeto Website'
      expect(page).to have_content 'Um site de jogos'
      expect(page).to have_content 'Programação'
    end
  end
end
