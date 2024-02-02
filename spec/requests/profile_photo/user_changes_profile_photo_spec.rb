require 'rails_helper'

describe 'Usuário altera foto de perfil' do
  context 'mas sem autorização' do
    it 'é redirecionado para homepage' do
      hacker = create(:user)
      victim = create(:user)
      victim.profile.photo.attach(Rails.root.join('spec/resources/photos/male-photo.jpg'))

      login_as hacker
      new_file = Rails.root.join('spec/resources/photos/another-male-photo.jpg')
      patch "/profiles/#{victim.profile.id}", params: { profile: { photo: file_fixture_upload(new_file, 'image/jpg') } }

      expect(victim.profile.photo.filename).to eq 'male-photo.jpg'
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq 'Você não possui autorização para essa ação'
    end
  end
end
