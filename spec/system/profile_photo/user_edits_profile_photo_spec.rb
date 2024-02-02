require 'rails_helper'

describe 'Usuário altera foto de perfil' do
  it 'com sucesso a partir da foto padrão de usuário' do
    user = create(:user)

    login_as user
    visit profile_path(user.profile)
    click_on 'Alterar foto'

    photo_path = Rails.root.join('spec/resources/photos/male-photo.jpg')
    attach_file('Foto', photo_path)
    click_on 'Salvar'

    expect(page).to have_current_path profile_path(user.profile)
    expect(page).to have_content 'Sua foto foi alterada com sucesso'
    expect(page).to have_css('img[src*="male-photo.jpg"]')
    expect(page).not_to have_css('img[src*="default_portfoliorrr_photo.png"]')
  end

  it 'com sucesso substituindo uma foto previamente cadastrada, e não armazena a foto antiga' do
    user = create(:user)
    user.profile.photo.attach(Rails.root.join('spec/resources/photos/male-photo.jpg'))

    login_as user
    visit profile_path(user.profile)
    click_on 'Alterar foto'
    new_photo_path = Rails.root.join('spec/resources/photos/another-male-photo.jpg')
    attach_file('Foto', new_photo_path)
    click_on 'Salvar'
    expect(ActiveStorage::Attachment.count).to eq 1
    expect(ActiveStorage::Blob.count).to eq 1
    expect(page).to have_css('img[src*="another-male-photo.jpg"]')
  end

  context 'mas se não possuir autorização' do
    it 'não vê o botão de alterar foto' do
      hacker = create(:user)
      victim = create(:user)

      login_as hacker
      visit profile_path(victim.profile)

      expect(page).not_to have_link 'Alterar foto', href: edit_profile_path(victim.profile)
    end

    it 'é redirecionado caso tente acessar o endereço de alterar foto' do
      hacker = create(:user)
      victim = create(:user)

      login_as hacker
      visit edit_profile_path(victim.profile)

      expect(page).to have_current_path root_path
      expect(page).to have_content 'Você não possui autorização para essa ação'
    end
  end

  it 'apenas se enviar um arquivo .jpg, .jpeg ou .png' do
    user = create(:user)

    login_as user
    visit edit_profile_path(user.profile)
    file_path = Rails.root.join('spec/resources/pdf/star_wars_script.pdf')
    attach_file('Foto', file_path)
    click_on 'Salvar'

    expect(user.profile.photo_attachment.filename).to eq 'default_portfoliorrr_photo.png'
    expect(page).to have_current_path edit_profile_path(user.profile)
    expect(page).to have_content 'Sua alteração não pôde ser salva'
    expect(page).to have_content 'Foto deve ser do formato .jpg, .jpeg ou .png'
  end

  it 'apenas se enviar um arquivo menor que 3MB' do
    user = create(:user)

    login_as user
    visit edit_profile_path(user.profile)
    file_path = Rails.root.join('spec/resources/photos/jennifer-lawrence.jpg')
    attach_file('Foto', file_path)
    click_on 'Salvar'

    expect(user.profile.photo_attachment.filename).to eq 'default_portfoliorrr_photo.png'
    expect(page).to have_current_path edit_profile_path(user.profile)
    expect(page).to have_content 'Sua alteração não pôde ser salva'
    expect(page).to have_content 'Foto deve ter no máximo 3MB'
  end
end
