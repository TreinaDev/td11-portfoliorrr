require 'rails_helper'

describe 'Usuário acessa página de convites' do
  context 'e visualiza seus convites' do
    it 'com sucesso' do
      invitation = create(:invitation)

      login_as invitation.profile.user
      visit root_path

      within 'nav' do
        click_button class: 'dropdown-toggle'
        click_on 'Convites'
      end

      expect(current_path).to eq invitations_path
      expect(page).to have_content invitation.project_title
      expect(page).to have_content invitation.project_description.truncate(50)
      expect(page).to have_content 'Expira em: 1 semana'
    end
  end

  xit 'e nao visualiza dos outros'

  xit 'e nao tem convites'
  xit 'e visualiza convites expirados'
  xit 'e visualiza convites aceitos'
end
