require 'rails_helper'

RSpec.describe InvitationRequest, type: :model do
  describe '#valid?' do
    it 'não pode solicitar convite para o mesmo projeto' do
      user = create(:user)
      create(:invitation_request, profile: user.profile)
      failed_request = InvitationRequest.new(profile: user.profile, project_id: 1)

      expect(failed_request).not_to be_valid
      expect(failed_request.errors[:profile]).to include('já está em uso')
    end
    it 'pode solicitar convite para outros projetos' do
      user = create(:user)
      create(:invitation_request, profile: user.profile)
      successful_request = InvitationRequest.new(profile: user.profile, project_id: 2)

      expect(successful_request).to be_valid
    end
  end
end
