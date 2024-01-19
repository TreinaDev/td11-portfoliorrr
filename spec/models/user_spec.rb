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

  describe '#valid?' do
    context 'presença' do
      it 'nome completo não pode ficar em branco' do
        user = User.new email: 'teste@email.com', password: '123456',
                        full_name: '', citizen_id_number: '88257290068'

        expect(user).not_to be_valid
      end

      it 'CPF não pode ficar em branco' do
        user = User.new email: 'teste@email.com', password: '123456',
                        full_name: 'Usuário A', citizen_id_number: ''

        expect(user).not_to be_valid
      end
    end

    context 'unicidade' do
      it 'CPF não pode estar em uso' do
        User.create! email: 'usuario_a@email.com', password: '123456',
                     full_name: 'Usuário A', citizen_id_number: '88257290068'

        user = User.new email: 'usuario_b@email.com', password: '123456',
                        full_name: 'Usuário B', citizen_id_number: '88257290068'

        expect(user).not_to be_valid
      end
    end

    context 'legitimidade' do
      it 'CPF deve ser reconhecido' do
        user = User.new email: 'usuario_b@email.com', password: '123456',
                        full_name: 'Usuário B', citizen_id_number: '88257290060'

        expect(user).not_to be_valid
      end
    end
end
