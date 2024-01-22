require 'rails_helper'

RSpec.describe Profile, type: :model do
  describe '#create_personal_info' do
    it 'cria as informações pessoais ao criar um perfil' do
      user = User.create(email: 'joaoalmeida@email', citizen_id_number: '38031825068',
                         password: '123456', full_name: 'João Almeida')

      expect(user.profile.personal_info).to be_present
    end
  end
end
