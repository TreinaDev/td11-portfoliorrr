require 'rails_helper'

describe 'Usuário não assinante' do
  it 'acessa página de solicitações e recebe mensagem para se tornar assinante' do
    user = create(:user, :free)

    login_as user
    visit root_path
    click_button class: 'dropdown-toggle'
    click_on 'Solicitações de Convite'

    expect(page).to have_current_path(invitation_requests_path)
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

  it 'se vê página para se tornar assinante' do
    user = create(:user, :free)

    login_as user
    visit root_path
    click_button class: 'dropdown-toggle'
    click_on 'Assinatura'

    within '#free-account-div' do
      expect(page).to have_content 'Plano atual'
    end

    within '#premium-account-div' do
      expect(page).to have_button 'Assinar'
      expect(page).to have_content 'Acesso à pesquisas de projetos na plataforma parceira Cola?bora!'
      expect(page).to have_content 'Destaque nos resultados das pesquisas por líderes de projetos.'
      expect(page).to have_content 'Solicitações de convites para participação de projetos ilimitadas.'
      expect(page).to have_content 'Zero anúncios na plataforma.'
    end
  end

  it 'se torna assinante' do
    user = create(:user, :free)

    login_as user
    visit root_path
    click_button class: 'dropdown-toggle'
    click_on 'Assinatura'
    click_on 'Assinar'

    expect(page).not_to have_content 'Assinar'
    expect(user.subscription.reload).to be_active
    expect(page).to have_content 'Assinatura atualizada com sucesso!'
    within '#premium-account-div' do
      expect(page).to have_content 'Plano atual'
    end
  end
end
