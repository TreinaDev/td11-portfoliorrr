require 'rails_helper'

describe 'Usuário assinante' do
  it 'acessa página de solicitações' do
    user = create(:user, :paid)

    login_as user
    visit root_path
    click_button class: 'dropdown-toggle'
    click_on 'Solicitações de Convite'

    expect(page).to have_current_path(invitation_requests_path)
    expect(page).to have_button 'Filtrar'
    expect(page).not_to have_content 'Torne-se assinante para ver e fazer solicitações'
  end

  it 'acessa página de projetos' do
    user = create(:user, :paid)

    login_as user
    visit root_path
    click_button class: 'dropdown-toggle'
    click_on 'Projetos'

    expect(page).to have_current_path(projects_path)
    expect(page).not_to have_content 'Torne-se assinante para ver projetos listados'
    expect(page).to have_button 'Título'
    expect(page).to have_button 'Todos'
  end
end
