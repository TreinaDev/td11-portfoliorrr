require 'rails_helper'

describe 'Usuário altera o status de disponibilidade de trabalho' do
  context 'de disponível para indisponível' do
    it 'com sucesso' do
      user = create(:user)

      login_as user
      visit profile_settings_path(user.profile)
      click_on 'Alterar Disponibilidade'

      expect(page).to have_current_path profile_settings_path(user.profile)
      expect(page).to have_content 'Alteração salva com sucesso'
      expect(page).to have_content 'Indisponível Para Trabalho'
    end
  end

  context 'de indisponível para disponível' do
    it 'com sucesso' do
      user = create(:user)
      user.profile.unavailable!

      login_as user
      visit profile_settings_path(user.profile)
      click_on 'Alterar Disponibilidade'

      expect(page).to have_current_path profile_settings_path(user.profile)
      expect(page).to have_content 'Alteração salva com sucesso'
      expect(page).to have_content 'Disponível Para Trabalho'
    end
  end
end
