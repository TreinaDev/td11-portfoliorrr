require 'rails_helper'

describe 'Usuário remove foto de perfil' do
  context 'mas sem autorização' do
    it 'é redirecionado para homepage' do
      hacker = create(:user)
      victim = create(:user)
      victim.profile.photo.attach(Rails.root.join('spec/resources/photos/male-photo.jpg'))

      login_as hacker
      patch "/profiles/#{victim.profile.id}/remove_photo"

      expect(victim.profile.photo.filename).to eq 'male-photo.jpg'
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq 'Você não têm permissão para realizar essa ação.'
    end
  end
end
