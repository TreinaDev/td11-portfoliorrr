require 'rails_helper'

RSpec.describe Profile, type: :model do
  describe '#create_personal_info' do
    it 'cria as informações pessoais ao criar um perfil' do
      profile = create(:profile)

      expect(profile.personal_info).to be_present
    end
  end
end
