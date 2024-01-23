require 'rails_helper'

describe 'Usuário edita informações profissionais' do
  context 'quando logado' do
    it 'com sucesso' do
      personal_info = create(:personal_info)
      login_as personal_info.profile.user

      visit edit_user_profile_path

      expect(page).to have_content('Experiência Profissional')

      fill_in 'Empresa', with: 'Campus Code'
      fill_in 'Cargo', with: 'Desenvolvedor Ruby On Rails'
      fill_in 'Entrada', with: '2012-12-25'
      fill_in 'Término', with: '2015-12-31'
      check 'Visível', id: 'profile_professional_infos_attributes_0_visibility'

      click_on 'Salvar'

      expect(current_path).to eq user_profile_path
      expect(page).to have_content 'Campus Code'
      expect(page).to have_content 'Desenvolvedor Ruby On Rails'
      expect(page).to have_content '25/12/2012'
      expect(page).to have_content '31/12/2015'
      expect(page).to have_content 'Visível: Sim'
    end

    it 'e campos vazios são permitidos' do
      personal_info = create(:personal_info)
      login_as personal_info.profile.user

      visit edit_user_profile_path

      expect(page).to have_content('Experiência Profissional')

      fill_in 'Empresa', with: ''
      fill_in 'Cargo', with: ''
      fill_in 'Entrada', with: ''
      fill_in 'Término', with: ''
      check 'Visível', id: 'profile_professional_infos_attributes_0_visibility'

      click_on 'Salvar'

      expect(current_path).to eq user_profile_path
    end

    it 'e atualiza somente alguns campos com sucesso' do
      user = create(:user)

      user.profile.personal_info = create(:personal_info, profile: user.profile)

      user.profile.professional_infos.create(
        company: 'Campus Code',
        position: 'Desenvolvedor Ruby on Rails',
        start_date: '25-12-2012',
        end_date: '31-12-2015'
      )

      login_as user

      visit edit_user_profile_path

      fill_in 'Empresa', with: 'Vindi'

      click_on 'Salvar'

      expect(page).to have_content 'Vindi'
      expect(page).to have_content user.profile.professional_infos.first.position
      expect(page).to have_content '25/12/2012'
      expect(page).to have_content '31/12/2015'
      expect(page).to have_content 'Visível: Sim'
    end
  end
end
