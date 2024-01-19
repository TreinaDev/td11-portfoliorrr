require 'rails_helper'

RSpec.describe User, type: :model do
  describe '.search' do
    it 'retorna uma instância de acordo com o valor da procura' do
      create(:user, email: 'joao@almeida.com', password: '123456', full_name: 'João CampusCode Almeida')
      create(:user, email: 'akaninja@email.com', password: 'usemogit', full_name: 'André Kanamura')
      create(:user, email: 'gabriel@campos.com', password: 'oigaleraaa', full_name: 'Gabriel Campos')

      result = User.search_by_full_name('amp')

      expect(result.all.count).to eq 2
      expect(result.first.full_name).to eq 'João CampusCode Almeida'
      expect(result.last.full_name).to eq 'Gabriel Campos'
    end
  end
end
