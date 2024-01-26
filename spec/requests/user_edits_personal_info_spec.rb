require 'rails_helper'

describe 'Usuário edita informações pessoais' do
  context 'logado' do
    it 'somente da sua própria conta' do
      user1 = create(:user)
      user2 = create(:user, email: 'user2@email.com', citizen_id_number: '10491233019')

      login_as user2

      patch user_profile_path, params: { profile: { personal_info: { street: 'Rua ABC' } } }

      expect(user1.personal_info.street).to_not be 'Rua ABC'
    end
  end

  context 'não está logado' do
    it 'sem sucesso' do
      user = create(:user)

      patch user_profile_path, params: { profile: { personal_info: { street: 'Rua ABC' } } }

      expect(user.personal_info.street).to_not be 'Rua ABC'
    end
  end
end
