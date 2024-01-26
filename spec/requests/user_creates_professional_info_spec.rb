require 'rails_helper'

describe 'Usuário cria informações profissionais' do
  context 'quando logado como outro usuário' do
    it 'e falha' do
      user1 = create(:user)
      user2 = create(:user, email: 'user2@email.com', citizen_id_number: '10491233019')

      login_as user1

      post user_profile_professional_infos_path, params: {
        professional_info: {
          company: 'Campus Code',
          position: 'Dev',
          start_date: '2020-12-12',
          end_date: '2022-12-12'
        }
      }

      expect(user2.professional_infos.count).to eq(0)
    end
  end
  context 'não está logado' do
    it 'sem sucesso' do
      create(:user)

      post user_profile_professional_infos_path, params: {
        professional_info: {
          company: 'Campus Code',
          position: 'Dev',
          start_date: '2020-12-12',
          end_date: '2022-12-12'
        }
      }

      expect(ProfessionalInfo.count).to eq(0)
    end
  end
end
