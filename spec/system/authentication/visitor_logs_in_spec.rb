require 'rails_helper'

describe 'Usuário faz login' do
  context 'com sucesso' do
    it 'como usuário comum' do
      create(:user, full_name: 'João', email: 'joaoalmeida@email.com', password: '123456')

      visit root_path
      click_on 'Entrar'
      within '#new_user' do
        fill_in 'E-mail', with: 'joaoalmeida@email.com'
        fill_in 'Senha', with: '123456'
        click_on 'Entrar'
      end

      expect(page).to have_current_path root_path
      expect(page).to have_content 'Login efetuado com sucesso'
      within 'nav' do
        click_button class: 'dropdown-toggle'
        expect(page).not_to have_link 'Entrar'
        expect(page).not_to have_link 'Cadastrar Usuário'
        expect(page).to have_content 'João'
      end
    end

    it 'como administrador' do
      admin = create(:user, :admin, full_name: 'João')

      login_as admin
      visit root_path
      click_button class: 'dropdown-toggle'

      expect(page).to have_content 'João (Admin)'
    end

    it 'e seu perfil é reativado caso estivesse inativo' do
      user = create(:user)
      user.profile.inactive!

      visit root_path
      click_on 'Entrar'
      within '#new_user' do
        fill_in 'E-mail', with: user.email
        fill_in 'Senha', with: user.password
        click_on 'Entrar'
      end

      expect(page).to have_content 'Sua conta foi reativada com sucesso'
      expect(user.profile.reload).to be_active
    end
  end

  it 'e realiza o log out com sucesso' do
    user = create(:user)

    login_as user

    visit root_path
    click_button class: 'dropdown-toggle'
    click_on 'Sair'

    expect(page).to have_current_path root_path
    expect(page).to have_content 'Logout efetuado com sucesso'
  end

  context 'e falha' do
    it 'e-mail e senha não conferem' do
      visit root_path

      click_on 'Entrar'

      within '#new_user' do
        fill_in 'E-mail', with: 'joaoalmeida@email.com'
        fill_in 'Senha', with: '123456'

        click_on 'Entrar'
      end
      expect(page).to have_content 'E-mail ou senha inválidos'
    end

    it 'e-mail ou senha estão em branco' do
      visit root_path

      click_on 'Entrar'

      within '#new_user' do
        fill_in 'E-mail', with: ''
        fill_in 'Senha', with: ''

        click_on 'Entrar'
      end
      expect(page).to have_content 'E-mail ou senha inválidos'
    end

    it 'e seu perfil foi removido pelos administradores' do
      user = create(:user)
      user.profile.inactive!
      user.profile.update removed: true

      visit root_path
      click_on 'Entrar'
      within '#new_user' do
        fill_in 'E-mail', with: user.email
        fill_in 'Senha', with: user.password
        click_on 'Entrar'
      end

      expect(page).to have_content 'Sua conta foi removida pelos adminitradores'
    end
  end
end
