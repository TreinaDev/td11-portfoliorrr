require 'rails_helper'

describe 'Usuário altera o privacidade do perfil' do
  context 'de público para privado' do
    it 'com sucesso' do
      user = create(:user)

      login_as user
      visit profile_path(user.profile)
      click_on 'alterar privacidade'

      expect(page).to have_current_path profile_path(user.profile)
      expect(page).to have_content 'Privacidade alterada com sucesso'
      expect(page).to have_content 'Perfil Privado'
    end

    it 'apenas do seu próprio perfil' do
      user = create(:user)
      another_user = create(:user)

      login_as another_user
      visit profile_path(user.profile)

      expect(page).not_to have_button 'alterar privacidade'
    end

    it 'e não aparece nas buscas' do
      job_category = create(:job_category, name: 'C++')
      private_user = create(:user)
      private_user.profile.private_profile!
      private_user.profile.profile_job_categories.create!(job_category:)
      public_user = create(:user)
      public_user.profile.profile_job_categories.create!(job_category:)
      searching_user = create(:user)

      login_as searching_user
      visit root_path
      fill_in 'Buscar Perfil', with: 'C++'
      click_on 'Pesquisar'

      expect(current_path).to eq search_profiles_path
      expect(page).to have_content('1 resultado para: C++')
      expect(page).not_to have_content private_user.full_name
      expect(page).to have_content public_user.full_name
    end

    it 'e dados não aparecem a outros usuários' do
      private_user = create(:user)
      profile = private_user.profile
      profile.private_profile!
      personal_info = create(:personal_info)
      professional_info = create(:professional_info)
      education_info = create(:education_info)
      job_category = create(:job_category)
      create(:profile_job_category)

      another_user = create(:user)

      login_as another_user
      visit profile_path(private_user.profile)

      expect(page).to have_content 'O perfil que você acessou é privado'
      expect(page).not_to have_content private_user.full_name
      expect(page).not_to have_content personal_info.street
      expect(page).not_to have_content personal_info.state
      expect(page).not_to have_content professional_info.company
      expect(page).not_to have_content professional_info.position
      expect(page).not_to have_content education_info.institution
      expect(page).not_to have_content education_info.course
      expect(page).not_to have_content job_category.name
    end
  end

  context 'de privado para público' do
    it 'com sucesso' do
      user = create(:user)
      user.profile.private_profile!

      login_as user
      visit profile_path(user.profile)
      click_on 'alterar privacidade'

      expect(page).to have_current_path profile_path(user.profile)
      expect(page).to have_content 'Privacidade alterada com sucesso'
      expect(page).to have_content 'Perfil Público'
    end
  end
end
