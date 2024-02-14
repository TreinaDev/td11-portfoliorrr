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

  describe '#accepted!' do
    it 'muda o status para accepted quando o atual é pending' do
      invitation_request = create(:invitation_request, status: :pending)

      invitation_request.accepted!

      expect(invitation_request.reload.status).to eq 'accepted'
    end

    it 'não muda o status para accepted quando o atual é processing' do
      invitation_request = create(:invitation_request, status: :processing)

      invitation_request.accepted!

      expect(invitation_request.reload.status).not_to eq 'accepted'
      expect(invitation_request.status).to eq 'processing'
    end

    it 'não muda o status para accepted quando o atual é refused' do
      invitation_request = create(:invitation_request, status: :refused)

      invitation_request.accepted!

      expect(invitation_request.reload.status).not_to eq 'accepted'
      expect(invitation_request.status).to eq 'refused'
    end

    it 'não muda o status para accepted quando o atual é error' do
      invitation_request = create(:invitation_request, status: :error)

      invitation_request.accepted!

      expect(invitation_request.reload.status).not_to eq 'accepted'
      expect(invitation_request.status).to eq 'error'
    end

    it 'não muda o status para accepted quando o atual é aborted' do
      invitation_request = create(:invitation_request, status: :aborted)

      invitation_request.accepted!

      expect(invitation_request.reload.status).not_to eq 'accepted'
      expect(invitation_request.status).to eq 'aborted'
    end
  end
end
