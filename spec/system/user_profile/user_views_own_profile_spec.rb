require 'rails_helper'

describe 'Usuário visualiza suas informações pessoais' do
  context 'quando logado' do
    it 'a partir da home' do
      user = create(:user, full_name: 'João Almeida', email: 'joaoalmeida@email.com')
      user.profile.personal_info.update(street: 'Avenida Campus Code', area: 'TreinaDev',
                                        city: 'São Paulo', state: 'SP', zip_code: '34123069',
                                        phone: '11 4002 8922', birth_date: '1980-12-25')

      login_as user
      visit root_path
      click_on 'Meu Perfil'

      expect(current_path).to eq user_profile_path
      expect(page).to have_content 'Avenida Campus Code'
      expect(page).to have_content 'João Almeida'
      expect(page).to have_content 'joaoalmeida@email.com'
      expect(page).to have_content 'TreinaDev'
      expect(page).to have_content 'São Paulo'
      expect(page).to have_content 'SP'
      expect(page).to have_content '34123069'
      expect(page).to have_content '11 4002 8922'
      expect(page).to have_content '25/12/1980'
    end
  end

  context 'quando não está logado' do
    it 'e é redirecionado para a página de login' do
      visit user_profile_path
      expect(current_path).to eq new_user_session_path
      expect(page).to have_content 'Para continuar, faça login ou registre-se'
    end
  end
end
