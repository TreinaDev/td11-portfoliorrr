require 'rails_helper'

RSpec.describe ProjectsService::ColaBoraApiGetProjects do
  context '.send' do
    it 'retorna array de objetos do tipo Project' do
      json_data = File.read(Rails.root.join('./spec/support/json/projects.json'))
      fake_response = double('faraday_response', success?: true, body: json_data)

      allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/projects').and_return(fake_response)

      result = ProjectsService::ColaBoraApiGetProjects.send

      json_response = JSON.parse(result.body)
      expect(json_response.class).to eq Array
      expect(json_response.count).to eq 4
    end
  end
end
