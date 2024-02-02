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

    context 'valor padrão' do
      it 'pending é o padrão para status' do
        profile = create(:profile)
        invitation = Invitation.create profile_id: profile.id,
                                       project_title: 'Projeto Cola?Bora!',
                                       project_description: 'Projeto Legal',
                                       project_category: 'Tecnologia',
                                       colabora_invitation_id: 1,
                                       message: 'Venha participar do meu projeto!',
                                       expiration_date: 1.week.from_now.to_date,
                                       status: 'accepted'

        expect(invitation.status).to eq 'pending'
        expect(invitation).to be_valid
      end
    end
  end
end
