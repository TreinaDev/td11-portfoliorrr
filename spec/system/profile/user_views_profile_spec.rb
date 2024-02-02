require 'rails_helper'

describe 'Usuário visualiza informações pessoais' do
  context 'quando autenticado e dono da conta' do
    it 'e vê as informações preenchidas' do
      user = create(:user, full_name: 'João Almeida', email: 'joaoalmeida@email.com')
      user.profile.personal_info.update(street: 'Avenida Campus Code', area: 'TreinaDev',
                                        city: 'São Paulo', state: 'SP', zip_code: '34123069',
                                        phone: '11 4002 8922', birth_date: '1980-12-25')

      login_as user
      visit root_path
      click_on 'João'

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

    it 'e vê os campos em branco' do
      user = create(:user, full_name: 'João Almeida', email: 'joaoalmeida@email.com')
      user.profile.personal_info.update(street: '', area: '',
                                        city: '', state: '', zip_code: '',
                                        phone: '', birth_date: '')

      login_as user
      visit root_path
      click_on 'João'

      expect(page).to have_content 'Rua:'
      expect(page).to have_content 'Número:'
      expect(page).to have_content 'Bairro:'
      expect(page).to have_content 'CEP:'
      expect(page).to have_content 'Cidade:'
      expect(page).to have_content 'Estado:'
      expect(page).to have_content 'Telefone:'
      expect(page).to have_content 'Data de Nascimento:'
    end
  end

  context 'quando autenticado e não é dono da conta' do
    it 'e vê somente as informações preenchidas' do
      user = create(:user, full_name: 'João Almeida', email: 'joaoalmeida@email.com')
      user.profile.personal_info.update(street: 'Avenida Campus Code', area: 'TreinaDev',
                                        city: 'São Paulo', state: 'SP', zip_code: '',
                                        phone: '', birth_date: '', visibility: true)
      user2 = create(:user, full_name: 'Andre')

      login_as user2
      visit profile_path(user.profile)

      expect(page).to have_content 'Avenida Campus Code'
      expect(page).to have_content 'João Almeida'
      expect(page).to have_content 'joaoalmeida@email.com'
      expect(page).to have_content 'TreinaDev'
      expect(page).to have_content 'São Paulo'
      expect(page).to have_content 'SP'
      expect(page).not_to have_content 'CEP:'
      expect(page).not_to have_content 'Telefone:'
      expect(page).not_to have_content 'Data de Nascimento:'
    end
  end

  context 'quando não está logado' do
    it 'e é redirecionado para a página de login' do
      user = create(:user)
      visit profile_path(user.profile)
      expect(current_path).to eq new_user_session_path
      expect(page).to have_content 'Para continuar, faça login ou registre-se'
    end
  end
end
