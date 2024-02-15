require 'rails_helper'

RSpec.describe InvitationRequestService::InvitationRequest do
  context '.send' do
    it 'retorna array de objetos com informações completas do convite' do
      user = create(:user)

      json_data = File.read(Rails.root.join('./spec/support/json/projects.json'))
      fake_response = double('faraday_response', success?: true, body: json_data)
      allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/projects').and_return(fake_response)

      request_one = create(:invitation_request,
                           project_id: 1,
                           profile: user.profile,
                           status: :pending)
      request_two = create(:invitation_request,
                           project_id: 2,
                           profile: user.profile,
                           status: :accepted)

      requests = [request_one, request_two]

      allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/projects').and_return(fake_response)

      result = InvitationRequestService::InvitationRequest.send(requests)

      expect(result.class).to eq Array
      expect(result.count).to eq 2
      expect(result.first.id).to eq request_one.id
      expect(result.first.project_id).to eq 1
      expect(result.first.project_title).to eq 'Padrão 1'
      expect(result.first.project_description).to eq 'Descrição de um projeto padrão para testes 1.'
      expect(result.first.project_category).to eq 'Categoria de projeto'
      expect(result.first.status).to eq 'pending'
      expect(result.first.created_at).to eq request_one.created_at

      expect(result.second.id).to eq request_two.id
      expect(result.second.project_id).to eq 2
      expect(result.second.project_title).to eq 'Líder de Ginásio'
      expect(result.second.project_description).to eq 'Me tornar líder do estádio de pedra.'
      expect(result.second.project_category).to eq 'Auto Ajuda'
      expect(result.second.status).to eq 'accepted'
      expect(result.second.created_at).to eq request_two.created_at
    end

    it 'retorna um array vazio quando não há solicitações de convite' do
      requests = []

      result = InvitationRequestService::InvitationRequest.send(requests)

      expect(result.class).to eq Array
      expect(result).to be_empty
    end
  end
end
