require 'rails_helper'

describe 'Administrador cadastra um anúncio' do
  it 'com sucesso' do
    admin = create(:user, role: 'admin')

    login_as admin
    visit root_path
    click_button class: 'dropdown-toggle'
    within 'nav' do
      click_on 'Anúncios'
    end
    click_on 'Criar Anúncio'
    fill_in 'Título', with: 'Buscador'
    fill_in 'Link', with: 'www.google.com'
    fill_in 'Prazo (em dias)', with: 7
    attach_file('Imagem', Rails.root.join('spec/support/assets/images/test_image.png'))
    click_on 'Salvar'

    ad = Advertisement.last
    expect(page).to have_current_path advertisement_path(ad)
    expect(page).to have_content 'Anúncio criado com sucesso'
    expect(page).to have_content 'Buscador'
    expect(page).to have_css('img[src*="test_image.png"]')
    expect(page).to have_link 'Voltar', href: advertisements_path
  end

  it 'e não é admin' do
    user = create(:user)

    login_as user
    visit root_path
    click_button class: 'dropdown-toggle'

    within 'nav' do
      expect(page).not_to have_link 'Anúncios'
    end
  end

  pending 'e visitante visualzia anúncio no feed'

  pending 'e view_count atualiza quando o anúncio é clicado'
end
