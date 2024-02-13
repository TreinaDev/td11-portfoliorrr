require 'rails_helper'

RSpec.describe InvitationRequestService::ColaboraProject do
  context '.send' do
    it 'retorna array de objetos do tipo Project' do
      json_data = File.read(Rails.root.join('./spec/support/json/projects.json'))
      fake_response = double('faraday_response', success?: true, body: json_data)
      projects = [
        Project.new(id: 1, title: 'Padrão 1',
                    description: 'Descrição de um projeto padrão para testes 1.',
                    category: 'Categoria de projeto'),
        Project.new(id: 2, title: 'Líder de Ginásio',
                    description: 'Me tornar líder do estádio de pedra.',
                    category: 'Auto Ajuda'),
        Project.new(id: 3, title: 'Pokedex',
                    description: 'Fazer uma listagem de todos os pokemons.',
                    category: 'Tecnologia'),
        Project.new(id: 4, title: 'Novo Projeto',
                    description: 'Mais uma desafio a frente',
                    category: 'Industrial')
      ]
      allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/projects').and_return(fake_response)
      allow(InvitationRequestService::ColaboraProject).to receive(:build_projects).and_return(projects)

      result = InvitationRequestService::ColaboraProject.send

      expect(result.class).to eq Array
      expect(result.count).to eq 4
      expect(result).to eq projects
    end

    it 'lança erro quando a resposta da API é sem sucesso' do
      fake_response = double('faraday_response', success?: false, status: :internal_server_error)
      allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/projects').and_return(fake_response)

      expect { InvitationRequestService::ColaboraProject.send }.to raise_error(StandardError)
    end
  end
end
