require 'rails_helper'

describe 'Usuário não assinante' do
  it 'acessa página de solicitações e recebe mensagem para se tornar assinante' do
    user = create(:user, :free)

    login_as user
    visit root_path
    click_button class: 'dropdown-toggle'
    click_on 'Solicitações de Convite'

    expect(page).to have_current_path(projects_path)
    expect(page).to have_content 'Torne-se assinante para ver e fazer solicitações'
  end

  it 'acessa página de projetos e recebe mensagem para se tornar assinante' do
    user = create(:user, :free)

    login_as user
    visit root_path
    click_button class: 'dropdown-toggle'
    click_on 'Projetos'

    expect(page).to have_current_path(projects_path)
    expect(page).to have_content 'Torne-se assinante para ver projetos listados'
  end
end
