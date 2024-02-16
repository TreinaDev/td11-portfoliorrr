require 'rails_helper'

describe 'Admin visita página de index de denúnicas' do
  it 'e visualiza denúncias pendentes' do
    admin = create(:user, :admin)
    report = create(:report, :for_post, offence_type: 'Discurso de ódio')
    other_report = create(:report, :for_comment, offence_type: 'Abuso/Perseguição')
    another_report = create(:report, :for_profile, offence_type: 'Spam', status: :granted)

    login_as admin
    visit root_path
    click_button class: 'dropdown-toggle'
    click_on 'Denúncias'

    expect(page).to have_content report.truncated_message
    expect(page).to have_content 'Discurso de ódio'
    expect(page).to have_content 'Publicação'
    expect(page).to have_content other_report.truncated_message
    expect(page).to have_content 'Abuso/Perseguição'
    expect(page).to have_content 'Comentário'
    expect(page).not_to have_content another_report.truncated_message
    expect(page).not_to have_content 'Spam'
    expect(page).not_to have_content 'Perfil'
    expect(page).to have_current_path reports_path
  end

  it 'e visualiza denúncias deferidas' do
    admin = create(:user, :admin)
    report = create(:report, :for_post, offence_type: 'Discurso de ódio')
    other_report = create(:report, :for_comment, offence_type: 'Abuso/Perseguição', status: :granted)
    another_report = create(:report, :for_profile, offence_type: 'Spam')

    login_as admin
    visit root_path
    click_button class: 'dropdown-toggle'
    click_on 'Denúncias'
    click_on 'Conteúdo removido'

    expect(page).not_to have_content report.truncated_message
    within 'main' do
      expect(page).not_to have_content 'Discurso de ódio'
      expect(page).not_to have_content 'Publicação'
      expect(page).to have_content other_report.truncated_message
      expect(page).to have_content 'Abuso/Perseguição'
      expect(page).to have_content 'Comentário'
      expect(page).not_to have_content another_report.truncated_message
      expect(page).not_to have_content 'Spam'
      expect(page).not_to have_content 'Perfil'
    end
    expect(page).to have_current_path reports_path({ filter: 'granted' })
  end

  it 'e visualiza denúncias indeferidas' do
    admin = create(:user, :admin)
    report = create(:report, :for_post, offence_type: 'Discurso de ódio', status: :rejected)
    other_report = create(:report, :for_comment, offence_type: 'Abuso/Perseguição')
    another_report = create(:report, :for_profile, offence_type: 'Spam')

    login_as admin
    visit root_path
    click_button class: 'dropdown-toggle'
    click_on 'Denúncias'
    click_on 'Denúncias rejeitadas'

    expect(page).to have_content report.truncated_message
    expect(page).to have_content 'Discurso de ódio'
    expect(page).to have_content 'Publicação'
    expect(page).not_to have_content other_report.truncated_message
    expect(page).not_to have_content 'Abuso/Perseguição'
    expect(page).not_to have_content 'Comentário'
    expect(page).not_to have_content another_report.truncated_message
    expect(page).not_to have_content 'Spam'
    expect(page).not_to have_content 'Perfil'
    expect(page).to have_current_path reports_path({ filter: 'rejected' })
  end

  it 'e não há denúncias disponíveis' do
    admin = create(:user, :admin)

    login_as admin
    visit reports_path

    expect(page).to have_content 'Nenhuma denúncia encontrada'
  end

  it 'e precisa estar logado' do
    visit reports_path

    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
    expect(page).to have_current_path new_user_session_path
  end

  it 'e precisa ser admin' do
    user = create(:user)

    login_as user
    visit reports_path

    expect(page).to have_current_path root_path
    expect(page).to have_content 'Você não têm permissão para realizar essa ação.'
  end
end
