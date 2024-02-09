require 'rails_helper'

describe 'Usuário acessa página de pedidos de convite' do
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

  it 'e não existem pedidos' do
    user = create(:user)

    login_as user
    visit invitation_requests_path

    expect(page).to have_content 'Você ainda não fez nenhuma solicitação de convite'
  end

  it 'e filtra por status "Processando"' do
    user = create(:user)
    processing_request_one = create(:invitation_request, profile: user.profile, message: 'Me aceita',
                                                         project_id: 1, status: :processing, created_at: 15.minutes.ago)
    processing_request_two = create(:invitation_request, profile: user.profile, message: 'Sou bom para este projeto',
                                                         project_id: 3, status: :processing, created_at: 3.hours.ago)
    accepted_request = create(:invitation_request, profile: user.profile, message: 'Sou bom para este projeto',
                                                   project_id: 2, status: :accepted, created_at: 2.days.ago)
    refused_request = create(:invitation_request, profile: user.profile, message: 'Sou bom para este projeto',
                                                  project_id: 4, status: :refused, created_at: 4.days.ago)

    json_data = File.read(Rails.root.join('./spec/support/json/projects.json'))
    fake_response = double('faraday_response', success?: true, body: json_data)
    allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/projects').and_return(fake_response)

    login_as user
    visit invitation_requests_path
    select 'Processando', from: :filter
    click_on 'Filtrar'

    within "#request_#{processing_request_one.id}" do
      expect(page).to have_content 'Padrão 1'
      expect(page).to have_content 'Descrição de um projeto padrão para testes 1.'
      expect(page).to have_content 'Categoria de projeto'
      expect(page).to have_content 'Enviada há 15 minutos'
      expect(page).to have_content 'Processando'
    end

    within "#request_#{processing_request_two.id}" do
      expect(page).to have_content 'Pokedex'
      expect(page).to have_content 'Fazer uma listagem de todos os pokemons.'
      expect(page).to have_content 'Tecnologia'
      expect(page).to have_content 'Enviada há aproximadamente 3 horas'
      expect(page).to have_content 'Processando'
    end

    expect(page).to_not have_content 'Líder de Ginásio'
    expect(page).not_to have_css "#request_#{accepted_request.id}"

    expect(page).to_not have_content 'Novo Projeto'
    expect(page).not_to have_css "#request_#{refused_request.id}"
  end

  pending 'e filtra por status "Pendente"'
  pending 'e filtra por status "Aceita"'
  pending 'e filtra por status "Recusada"'
  pending 'e filtra por status "Erro"'
  pending 'e filtra por status "Cancelada"'

  pending 'e API retorna lista de projetos vazia'
end
