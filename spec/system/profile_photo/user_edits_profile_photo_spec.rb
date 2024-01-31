require 'rails_helper'

describe 'Usuário altera foto de perfil' do
  it 'com sucesso a partir da foto padrão de usuário' do
    user = create(:user)

    login_as user
    visit profile_path(user.profile)
    click_on 'Alterar foto'
    
    photo_path = Rails.root + 'spec/resources/photos/male-photo.jpg'
    attach_file('Foto', photo_path)
    click_on 'Salvar'
    
    expect(page).to have_current_path profile_path(user.profile)
    expect(page).to have_content 'Sua foto foi alterada com sucesso'
    expect(page).to have_css('img[src*="male-photo.jpg"]')
    expect(page).not_to have_css('img[src*="default_portfoliorrr_photo.png"]')
  end
end 