require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid?' do
    context 'presença' do
      it 'deve ser inválido se full_name está em branco' do
        user = User.new email: 'teste@email.com', password: '123456',
                        full_name: '', citizen_id_number: '88257290068'

        expect(user).not_to be_valid
      end

      it 'deve ser inválido se citizen_id_number está em branco' do
        user = User.new email: 'teste@email.com', password: '123456',
                        full_name: 'Usuário A', citizen_id_number: ''

        expect(user).not_to be_valid
      end
    end

    context 'unicidade' do
      it 'deve ser inválido se citizen_id_number já está em uso' do
        User.create! email: 'usuario_a@email.com', password: '123456',
                     full_name: 'Usuário A', citizen_id_number: '88257290068'

        user = User.new email: 'usuario_b@email.com', password: '123456',
                        full_name: 'Usuário B', citizen_id_number: '88257290068'

        expect(user).not_to be_valid
      end
    end
  end
end
