require 'rails_helper'

describe 'Usuário solicita convite para projetos' do
  context 'quando logado' do
    it 'com sucesso' do
      json_projects_data = File.read(Rails.root.join('./spec/support/json/projects.json'))

      fake_projects_response = double('faraday_response', status: 200, body: json_projects_data)

      allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/projects').and_return(fake_projects_response)

      user = create(:user)

      login_as user

      visit projects_path

      click_on 'Solicitar Convite', match: :first
      fill_in 'Mensagem', with: 'Sou muito bom de mais da conta'
      click_button 'Enviar'

      expect(page).to have_content 'Solicitação enviada com sucesso!'
      expect(user.profile.invitation_requests.count).to eq 1
      expect(page).to have_button 'Convite Solicitado', disabled: true
      expect(page).to have_button 'Solicitar Convite', count: 2
    end

    it 'e não é necessário passar uma mensagem' do
      json_projects_data = File.read(Rails.root.join('./spec/support/json/projects.json'))

      fake_projects_response = double('faraday_response', status: 200, body: json_projects_data)

      allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/projects').and_return(fake_projects_response)

      user = create(:user)

      login_as user

      visit projects_path

      click_on 'Solicitar Convite', match: :first
      click_button 'Enviar'

      expect(page).to have_content 'Solicitação enviada com sucesso!'
      expect(user.profile.invitation_requests.count).to eq 1
      expect(page).to have_button 'Convite Solicitado', disabled: true
      expect(page).to have_button 'Solicitar Convite', count: 2
    end
  end
end
