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

  it 'com sucesso substituindo uma foto previamente cadastrada, e não armazena a foto antiga' do
    user = create(:user)
    user.profile.photo.attach(Rails.root + 'spec/resources/photos/male-photo.jpg')

    login_as user
    visit profile_path(user.profile)
    click_on 'Alterar foto'
    new_photo_path = Rails.root + 'spec/resources/photos/another-male-photo.jpg'
    attach_file('Foto', new_photo_path)
    click_on 'Salvar'

    expect(ActiveStorage::Attachment.count).to eq 1
    expect(ActiveStorage::Blob.count).to eq 1
    expect(page).to have_css('img[src*="another-male-photo.jpg"]')
  end

  context 'apenas de seu próprio perfil' do
    pending 'por não ver o botão de alterar foto'
    pending 'por ser redirecionado caso tente acessar o endereço de alterar foto'
  end
  pending 'apenas se enviar um arquivo .jpg ou .png'
  pending 'apenas se enviar um arquivo menor que 3MB'
end