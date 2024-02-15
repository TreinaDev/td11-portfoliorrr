require 'rails_helper'

describe 'Usuário acessa página de convites' do
  context 'e visualiza seus convites' do
    it 'com sucesso' do
      user = create(:user)
      invitation = create(:invitation, profile: user.profile, expiration_date: Time.zone.now.to_date + 7)
      login_as invitation.profile.user

      visit root_path
      within 'nav' do
        click_button class: 'dropdown-toggle'
        click_on 'Convites'
      end

      expect(page).to have_current_path invitations_path
      expect(page).to have_content 'Projeto Cola?Bora!'
      expect(page).to have_content 'Um projeto muito legal'
      expect(page).to have_content "Expira dia: #{I18n.l(invitation.expiration_date, format: :default)}"
    end

    it 'e nao tem convites' do
      user = create(:user)

      login_as user
      visit invitations_path

      expect(page).to have_content 'Nenhum convite encontrado'
    end

    it 'e visualiza convites expirados' do
      user = create(:user)
      expired_invitation = build(:invitation, profile: user.profile, status: 'expired', expiration_date: 7.days.ago)
      expired_invitation.save(validate: false)
      _pending_invitation = create(:invitation, profile: user.profile, project_title: 'Projeto Gotta cath`em all',
                                                project_description: 'Capturar todos os Pokémons',
                                                project_category: 'Collection', colabora_invitation_id: 2)

      login_as user
      visit invitations_path
      click_on 'Expirados'

      expect(page).to have_content 'Projeto Cola?Bora!'
      expect(page).not_to have_content 'Projeto Gotta cath`em all'
    end

    it 'e visualiza convites pendentes' do
      user = create(:user)
      _accepted_invitation = create(:invitation, profile: user.profile, status: 'accepted')
      _pending_invitation = create(:invitation, profile: user.profile, project_title: 'Projeto Gotta cath`em all',
                                                project_description: 'Capturar todos os Pokémons',
                                                project_category: 'Collection', colabora_invitation_id: 2)

      login_as user
      visit invitations_path
      click_on 'Pendentes'

      expect(page).not_to have_content 'Projeto Cola?Bora!'
      expect(page).not_to have_content 'Um projeto muito legal'
      expect(page).to have_content 'Projeto Gotta cath`em all'
      expect(page).to have_content 'Capturar todos os Pokémons'
    end

    it 'e visualiza convites aceitos' do
      user = create(:user)
      _accepted_invitation = create(:invitation, profile: user.profile, status: 'accepted')
      _pending_invitation = create(:invitation, profile: user.profile, project_title: 'Projeto Gotta cath`em all',
                                                project_description: 'Capturar todos os Pokémons',
                                                project_category: 'Collection', colabora_invitation_id: 2)

      login_as user
      visit invitations_path
      click_on 'Aceitos'

      expect(page).to have_content 'Projeto Cola?Bora!'
      expect(page).to have_content 'Um projeto muito legal'
      expect(page).not_to have_content 'Projeto Gotta cath`em all'
      expect(page).not_to have_content 'Capturar todos os Pokémons'
    end

    it 'e visualiza convites rejeitados' do
      user = create(:user)
      _declined_invitation = create(:invitation, profile: user.profile, status: 'declined')
      _pending_invitation = create(:invitation, profile: user.profile, project_title: 'Projeto Gotta cath`em all',
                                                project_description: 'Capturar todos os Pokémons',
                                                project_category: 'Collection', colabora_invitation_id: 2)

      login_as user
      visit invitations_path
      click_on 'Recusados'

      expect(page).to have_content 'Projeto Cola?Bora!'
      expect(page).to have_content 'Um projeto muito legal'
      expect(page).not_to have_content 'Projeto Gotta cath`em all'
      expect(page).not_to have_content 'Capturar todos os Pokémons'
    end
  end

  it 'e visualiza convites cancelados' do
    user = create(:user)
    cancelled_invitation = build(:invitation, profile: user.profile, status: 'cancelled')
    cancelled_invitation.save(validate: false)
    _pending_invitation = create(:invitation, profile: user.profile, project_title: 'Projeto Gotta cath`em all',
                                              project_description: 'Capturar todos os Pokémons',
                                              project_category: 'Collection', colabora_invitation_id: 2)

    login_as user
    visit invitations_path
    click_on 'Cancelados'

    expect(page).to have_content 'Projeto Cola?Bora!'
    expect(page).not_to have_content 'Projeto Gotta cath`em all'
  end

  it 'e nao visualiza dos outros' do
    user = create(:user)
    other_user = create(:user)
    _invitation = create(:invitation, profile: user.profile)
    _other_user_invitation = create(:invitation,
                                    profile: other_user.profile, project_title: 'Projeto Gotta cath`em all',
                                    project_description: 'Capturar todos os Pokémons',
                                    project_category: 'Collection', colabora_invitation_id: 2)

    login_as user

    visit invitations_path

    expect(page).to have_content 'Projeto Cola?Bora!'
    expect(page).to have_content 'Um projeto muito legal'
    expect(page).not_to have_content 'Projeto Gotta cath`em all'
    expect(page).not_to have_content 'Capturar todos os Pokémons'
  end

  it 'mas precisa estar logado' do
    visit invitations_path

    expect(page).to have_current_path new_user_session_path
  end
end
