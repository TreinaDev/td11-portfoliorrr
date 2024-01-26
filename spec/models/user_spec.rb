require 'rails_helper'

RSpec.describe User, type: :model do
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

  describe '#create_profile' do
    it 'cria um perfil após criação de usuário' do
      user = User.create(email: 'joaoalmeida@email', citizen_id_number: '38031825068',
                         password: '123456', full_name: 'João Almeida')

      expect(user.profile).to be_present
    end
  end

  describe '#description' do
    it 'retorna o nome do usuário' do
      user = create(:user, full_name: 'João Almeida')

      expect(user.description).to eq 'João'
    end

    it 'retorna o nome e indicativo de admin' do
      user = create(:user, :admin, full_name: 'João Almeida')

      expect(user.description).to eq 'João (Admin)'
    end
  end
end
