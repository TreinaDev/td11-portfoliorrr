require 'rails_helper'

describe 'Usuário remove a foto de perfil' do
  it 'a partir do próprio perfil com sucesso' do
    user = create(:user)
    user.profile.photo.attach(Rails.root.join('spec/resources/photos/male-photo.jpg'))

    login_as user
    visit profile_path(user.profile)
    click_on 'Alterar foto'
    click_on 'Remover foto de perfil'

    expect(page).to have_current_path profile_path(user.profile)
    expect(page).to have_content 'Sua foto foi removida com sucesso'
    expect(page).not_to have_css('img[src*="male-photo.jpg"]')
    expect(page).to have_css('img[src*="default_portfoliorrr_photo.png"]')
  end
end
