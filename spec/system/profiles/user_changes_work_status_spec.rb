require 'rails_helper'

describe 'Usuário altera o status de disponibilidade de trabalho' do
  context 'de disponível para indisponível' do
    it 'com sucesso' do
      user = create(:user)

      login_as user
      visit profile_path(user.profile)
      click_on 'Não estou disponível para trabalho'

      expect(page).to have_current_path profile_path(user.profile)
      expect(page).to have_content 'Alteração salva com sucesso'
      expect(page).not_to have_button 'Não estou disponível para trabalho'
      expect(page).to have_content 'Indisponível Para Trabalho'
    end

    it 'apenas do seu próprio perfil' do
      user_a = create(:user)
      user_b = create(:user)

      login_as user_b
      visit profile_path(user_a.profile)

      expect(page).to have_content 'Disponível Para Trabalho'
      expect(page).not_to have_button 'Não estou disponível para trabalho'
    end
  end

  context 'de indisponível para disponível' do
    it 'com sucesso' do
      user = create(:user)
      user.profile.unavailable!

      login_as user
      visit profile_path(user.profile)
      click_on 'Estou disponível para trabalho'

      expect(page).to have_current_path profile_path(user.profile)
      expect(page).to have_content 'Alteração salva com sucesso'
      expect(page).not_to have_button 'Estou disponível para trabalho'
      expect(page).to have_content 'Disponível Para Trabalho'
    end

    it 'apenas do seu próprio perfil' do
      user_a = create(:user)
      user_b = create(:user)
      user_a.profile.unavailable!

      login_as user_b
      visit profile_path(user_a.profile)

      expect(page).to have_content 'Indisponível Para Trabalho'
      expect(page).not_to have_button 'Estou disponível para trabalho'
    end
  end
end
