require 'rails_helper'

describe 'Usuário visualiza pedidos de convite' do
  it 'a partir da home' do
    user = create(:user)
    create(:invitation_request, profile: user.profile, message: 'Me aceita',
                                project_id: 1, status: :pending, created_at: 1.day.ago)
    create(:invitation_request, profile: user.profile, message: 'Sou bom para este projeto',
                                project_id: 2, status: :refused, created_at: 2.days.ago)

    json_data = File.read(Rails.root.join('./spec/support/json/projects.json'))
    fake_response = double('faraday_response', success?: true, body: json_data)
    allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/projects').and_return(fake_response)

    login_as user
    visit root_path
    within 'nav' do
      click_button class: 'dropdown-toggle'
      click_on 'Solicitações de Convite'
    end

    expect(page).to have_content 'Padrão 1'
    expect(page).to have_content 'Descrição de um projeto padrão para testes 1.'
    expect(page).to have_content 'Categoria de projeto'
    expect(page).to have_content 'Enviada há 1 dia'
    expect(page).to have_content 'Pendente'

    expect(page).to have_content 'Líder de Ginásio'
    expect(page).to have_content 'Me tornar líder do estádio de pedra.'
    expect(page).to have_content 'Auto Ajuda'
    expect(page).to have_content 'Enviada há 2 dias'
    expect(page).to have_content 'Recusada'
  end
end
