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
      fill_in 'Data de Entrada', with: '2012-12-25'
      fill_in 'Data de Saída', with: '2015-12-31'
      fill_in 'Descrição', with: 'Fazia muito código'

      expect(page).to have_unchecked_field 'Vínculo Atual'

      check 'Visível', id: 'profile_professional_infos_attributes_0_visibility'

      click_on 'Salvar'

      expect(current_path).to eq user_profile_path
      expect(page).to have_content 'Campus Code'
      expect(page).to have_content 'Vínculo Atual: Não'
      expect(page).to have_content 'Desenvolvedor Ruby On Rails'
      expect(page).to have_content 'Fazia muito código'
      expect(page).to have_content '25/12/2012'
      expect(page).to have_content '31/12/2015'
      expect(page).to have_content 'Visível: Sim'
    end

    it 'e os campos "Empresa", "Cargo" e "Data de Entrada" são obrigatórios' do
      personal_info = create(:personal_info)
      login_as personal_info.profile.user

      visit edit_user_profile_path

      expect(page).to have_content('Experiência Profissional')

      fill_in 'Empresa', with: ''
      fill_in 'Cargo', with: ''
      fill_in 'Data de Entrada', with: ''
      fill_in 'Data de Saída', with: ''
      check 'Visível', id: 'profile_professional_infos_attributes_0_visibility'

      click_on 'Salvar'

      expect(current_path).to eq edit_user_profile_path

      expect(page).to have_content 'Não foi possível atualizar a experiência profissional'
      expect(page).to have_content 'Empresa não pode ficar em branco'
      expect(page).to have_content 'Cargo não pode ficar em branco'
      expect(page).to have_content 'Data de Entrada não pode ficar em branco'
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
