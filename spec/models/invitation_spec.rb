require 'rails_helper'

RSpec.describe Invitation, type: :model do
  describe '#valid?' do
    context 'presença' do
      it 'campos não podem ficar vazios' do
        invitation = Invitation.new profile_id: '',
                                    project_title: '',
                                    project_description: '',
                                    project_category: '',
                                    colabora_invitation_id: '',
                                    message: '',
                                    expiration_date: '',
                                    status: ''

        expect(invitation).not_to be_valid
        expect(invitation.errors[:profile_id]).to eq ['não pode ficar em branco']
        expect(invitation.errors[:project_title]).to eq ['não pode ficar em branco']
        expect(invitation.errors[:project_description]).to eq ['não pode ficar em branco']
        expect(invitation.errors[:project_category]).to eq ['não pode ficar em branco']
        expect(invitation.errors[:colabora_invitation_id]).to eq ['não pode ficar em branco']
        expect(invitation.errors.key?(:message)).to eq false
        expect(invitation.errors.key?(:expiration_date)).to eq false
      end
    end

    it 'data de expiração deve ser maior que a data atual' do
      invitation = Invitation.new expiration_date: 1.day.ago.to_date

      expect(invitation).not_to be_valid
      expect(invitation.errors[:expiration_date]).to eq ['deve ser maior que a data atual']
    end
  end
end
