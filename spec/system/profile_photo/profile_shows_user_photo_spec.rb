require 'rails_helper'

describe 'Perfil mostra foto do usuário' do
  context 'que ainda não adicionou uma foto própria' do
    it 'usando uma imagem padrão para qualquer usuário' do
      user_a = create(:user)
      user_b = create(:user)

      login_as user_b
      visit profile_path(user_a.profile)
    
      expect(page).to have_content user_a.full_name
      expect(page).to have_css('img[src*="default_portfoliorrr_photo.png"]')
    end
  end

  context 'após adicionar uma foto própria' do
    pending 'e mostra a foto correta para qualquer usuário da plataforma'
  end
end