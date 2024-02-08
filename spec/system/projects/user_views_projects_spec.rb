require 'rails_helper'

describe 'Usuário visita página de projetos' do
  context 'quando logado' do
    it 'e vê projetos cadastrados no Cola?Bora!' do
      json_data = File.read(Rails.root.join('./spec/support/json/projects.json'))

      fake_response = double('faraday_response', status: 200, body: json_data)

      allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/projects').and_return(fake_response)

      user = create(:user)

      login_as user

      visit root_path

      click_button class: 'dropdown-toggle'
      click_on 'Projetos'

      expect(page).to have_current_path projects_path
      expect(page).to have_content('Pesquisa de Projetos no Cola?Bora!')

      expect(page).to have_content 'Padrão 1'
      expect(page).to have_content 'Descrição: Descrição de um projeto padrão para testes 1.'
      expect(page).to have_content 'Categoria: Categoria de projeto'

      expect(page).to have_content 'Líder de Ginásio'
      expect(page).to have_content 'Me tornar líder do estádio de pedra.'
      expect(page).to have_content 'Auto Ajuda'

      expect(page).to have_content 'Pokedex'
      expect(page).to have_content 'Fazer uma listagem de todos os pokemons.'
      expect(page).to have_content 'Tecnologia'
    end

    it 'e não existem projetos cadastrados na API' do
      json_data = { message: 'Nenhum projeto encontrado.' }

      fake_response = double('faraday_response', status: 200, body: json_data.to_json)

      allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/projects').and_return(fake_response)

      user = create(:user)
      login_as user
      visit projects_path

      expect(page).to have_content('Não há projetos cadastrados no momento.')
      expect(page).to_not have_field('Pesquisar por ')
      expect(page).to_not have_field('Pesquisar por Categoria')
      expect(page).to_not have_field('Pesquisar por Descrição')
    end

    it 'e pesquisa projeto por título' do
      json_data = File.read(Rails.root.join('./spec/support/json/projects.json'))

      fake_response = double('faraday_response', status: 200, body: json_data)

      allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/projects').and_return(fake_response)

      user = create(:user)

      login_as user
      visit projects_path

      fill_in 'Pesquisar', with: 'Poke'
      click_button 'Título'

      expect(page).to have_content 'Pokedex'
      expect(page).to have_content 'Descrição: Fazer uma listagem de todos os pokemons'
      expect(page).to have_content 'Categoria: Tecnologia'

      expect(page).to_not have_content 'Padrão 1'
      expect(page).to_not have_content 'Descrição: Descrição de um projeto padrão para testes 1.'
      expect(page).to_not have_content 'Categoria: Categoria de projeto'

      expect(page).to_not have_content 'Líder de Ginásio'
      expect(page).to_not have_content 'Me tornar líder do estádio de pedra.'
      expect(page).to_not have_content 'Auto Ajuda'
    end

    it 'e pesquisa projeto por categoria' do
      json_data = File.read(Rails.root.join('./spec/support/json/projects.json'))

      fake_response = double('faraday_response', status: 200, body: json_data)

      allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/projects').and_return(fake_response)

      user = create(:user)
      login_as user
      visit projects_path

      fill_in 'Pesquisar', with: 'Tecno'
      click_button 'Categoria'

      expect(page).to have_content 'Pokedex'
      expect(page).to have_content 'Descrição: Fazer uma listagem de todos os pokemons'
      expect(page).to have_content 'Categoria: Tecnologia'

      expect(page).to_not have_content 'Padrão 1'
      expect(page).to_not have_content 'Descrição: Descrição de um projeto padrão para testes 1.'
      expect(page).to_not have_content 'Categoria: Categoria de projeto'

      expect(page).to_not have_content 'Líder de Ginásio'
      expect(page).to_not have_content 'Me tornar líder do estádio de pedra.'
      expect(page).to_not have_content 'Auto Ajuda'
    end

    it 'e pesquisa projeto por descrição' do
      json_data = File.read(Rails.root.join('./spec/support/json/projects.json'))

      fake_response = double('faraday_response', status: 200, body: json_data)

      allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/projects').and_return(fake_response)

      user = create(:user)
      login_as user
      visit projects_path

      fill_in 'Pesquisar', with: 'pokem'
      click_button 'Descrição'

      expect(page).to have_content 'Pokedex'
      expect(page).to have_content 'Descrição: Fazer uma listagem de todos os pokemons'
      expect(page).to have_content 'Categoria: Tecnologia'

      expect(page).to_not have_content 'Padrão 1'
      expect(page).to_not have_content 'Descrição: Descrição de um projeto padrão para testes 1.'
      expect(page).to_not have_content 'Categoria: Categoria de projeto'

      expect(page).to_not have_content 'Líder de Ginásio'
      expect(page).to_not have_content 'Me tornar líder do estádio de pedra.'
      expect(page).to_not have_content 'Auto Ajuda'
    end

    it 'e pesquisa projeto por título, categoria e descrição' do
      json_data = File.read(Rails.root.join('./spec/support/json/projects.json'))

      fake_response = double('faraday_response', status: 200, body: json_data)

      allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/projects').and_return(fake_response)

      user = create(:user)
      login_as user
      visit projects_path

      fill_in 'Pesquisar', with: 'Te'
      click_button 'Todos'

      expect(page).to have_content 'Pokedex'
      expect(page).to have_content 'Descrição: Fazer uma listagem de todos os pokemons'
      expect(page).to have_content 'Categoria: Tecnologia'

      expect(page).to have_content 'Padrão 1'
      expect(page).to have_content 'Descrição: Descrição de um projeto padrão para testes 1.'
      expect(page).to have_content 'Categoria: Categoria de projeto'

      expect(page).to_not have_content 'Líder de Ginásio'
      expect(page).to_not have_content 'Me tornar líder do estádio de pedra.'
      expect(page).to_not have_content 'Auto Ajuda'
    end

    it 'não encontra projetos ao pesquisar' do
      json_data = File.read(Rails.root.join('./spec/support/json/projects.json'))

      fake_response = double('faraday_response', status: 200, body: json_data)

      allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/projects').and_return(fake_response)

      user = create(:user)
      login_as user
      visit projects_path

      fill_in 'Pesquisar', with: 'Criar um foguete'

      expect(page).to have_content 'Não foi possível encontrar nenhum projeto.'

      expect(page).to_not have_content 'Pokedex'
      expect(page).to_not have_content 'Descrição: Fazer uma listagem de todos os pokemons'
      expect(page).to_not have_content 'Categoria: Tecnologia'

      expect(page).to_not have_content 'Padrão 1'
      expect(page).to_not have_content 'Descrição: Descrição de um projeto padrão para testes 1.'
      expect(page).to_not have_content 'Categoria: Categoria de projeto'

      expect(page).to_not have_content 'Líder de Ginásio'
      expect(page).to_not have_content 'Me tornar líder do estádio de pedra.'
      expect(page).to_not have_content 'Auto Ajuda'
    end

    it 'e mostra mensagem de erro para status 500' do
      response = { errors: ['Erro interno de servidor.'] }
      fake_response = double('faraday_response', status: :internal_server_error, body: response.to_json)

      allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/projects').and_return(fake_response)

      user = create(:user)
      login_as user
      visit projects_path
      expect(page).to have_content('Não foi possível carregar os projetos. Tente mais tarde')
    end

    it 'e mostra mensagem de erro para falha de conexão' do
      response = { error: 'Recurso não disponível' }
      fake_response = double('faraday_response', status: :service_unavailable, body: response.to_json)

      allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/projects').and_return(fake_response)

      user = create(:user)
      login_as user
      visit projects_path
      expect(page).to have_content('Não foi possível carregar os projetos. Tente mais tarde')
    end
  end

  context 'quando deslogado' do
    it 'e é redirecionado' do
      visit projects_path

      expect(page).to have_current_path(new_user_session_path)
      expect(page).to_not have_link('Projetos')
    end
  end

  it 'e a API retorna 500' do
    json_data = File.read(Rails.root.join('./spec/support/json/errors.json'))
    fake_response = double('faraday_response', status: 500, body: json_data)

    allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/projects').and_return(fake_response)

    user = create(:user)
    login_as user
    visit root_path
    click_button class: 'dropdown-toggle'
    click_on 'Projetos'

    expect(page).to have_content 'Não foi possível encontrar nenhum projeto.'
  end
end
