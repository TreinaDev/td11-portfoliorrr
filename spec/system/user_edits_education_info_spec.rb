require 'rails_helper'

describe 'Usuário edita informações sobre sua formação' do
  context 'quando logado' do
    it 'com sucesso' do
      user = create(:user)

      personal_info = create(:personal_info, profile: user.profile)

      personal_info.profile.professional_infos.create(
        company: 'Campus Code',
        position: 'Dev',
        start_date: '2012-12-12',
        end_date: '2013-12-12'
      )

      login_as user

      visit edit_user_profile_path

      expect(page).to have_content('Formação Acadêmica')

      fill_in 'Instituição', with: 'UFJF'
      fill_in 'Curso', with: 'Bacharelado em Ciência da Computação'
      fill_in 'Início', with: '2012-12-25'
      fill_in 'Término', id: 'profile_education_infos_attributes_0_end_date', with: '2015-12-31'
      check 'Visível', id: 'profile_education_infos_attributes_0_visibility'

      click_on 'Salvar'

      expect(current_path).to eq user_profile_path
      expect(page).to have_content 'UFJF'
      expect(page).to have_content 'Bacharelado em Ciência da Computação'
      expect(page).to have_content '25/12/2012'
      expect(page).to have_content '31/12/2015'
      expect(page).to have_content 'Visível: Sim'
    end

    it 'e campos vazios são permitidos' do
      user = create(:user)

      personal_info = create(:personal_info, profile: user.profile)

      personal_info.profile.professional_infos.create(
        company: 'Campus Code',
        position: 'Dev',
        start_date: '2012-12-12',
        end_date: '2013-12-12'
      )

      login_as user

      visit edit_user_profile_path

      expect(page).to have_content('Formação')

      fill_in 'Instituição', with: ''
      fill_in 'Curso', with: ''
      fill_in 'Início', with: ''
      fill_in 'Término', with: ''
      check 'Visível', id: 'profile_education_infos_attributes_0_visibility'

      click_on 'Salvar'

      expect(current_path).to eq user_profile_path
    end

    it 'e atualiza somente alguns campos com sucesso' do
      user = create(:user)

      personal_info = create(:personal_info, profile: user.profile)

      personal_info.profile.professional_infos.create(
        company: 'Campus Code',
        position: 'Dev',
        start_date: '2012-12-12',
        end_date: '2013-12-12'
      )

      user.profile.education_infos.create(
        institution: 'UFJF',
        course: 'Bacharelado em Ciência da Computação',
        start_date: '25-12-2012',
        end_date: '31-12-2015'
      )

      login_as user

      visit edit_user_profile_path

      fill_in 'Instituição', with: 'USP'

      click_on 'Salvar'

      expect(page).to have_content 'USP'
      expect(page).to have_content user.profile.education_infos.first.course
      expect(page).to have_content '25/12/2012'
      expect(page).to have_content '31/12/2015'
      expect(page).to have_content 'Visível: Sim'
    end
  end
end
