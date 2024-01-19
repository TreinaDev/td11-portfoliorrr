require 'rails_helper'

describe 'Usuário acessa a página de login' do
  it 'e realiza o log in com sucesso' do
    create(:user, email: 'joaoalmeida@email.com', password: '123456')

    visit root_path

    click_on 'Entrar'

    within '#new_user' do
      fill_in 'E-mail', with: 'joaoalmeida@email.com'
      fill_in 'Senha', with: '123456'

      click_on 'Entrar'
    end

    expect(current_path).to eq root_path
    expect(page).to have_content 'Login efetuado com sucesso'

    within 'nav' do
      expect(page).not_to have_link 'Entrar'
      expect(page).not_to have_link 'Cadastrar Usuário'
    end
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
  end
end
