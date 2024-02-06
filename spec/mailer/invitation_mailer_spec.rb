require 'rails_helper'

RSpec.describe InvitationsMailer, type: :mailer do
  context 'invitation' do
    it 'email caso receba um convite para projeto' do
      profile = create(:profile)
      invitation = create(:invitation, profile:)
      mail = InvitationsMailer.with(invitation).received_invitation

      expect(mail.subject).to include 'Você recebeu um convite'
      expect(mail.to).to eq [profile.user.email]
      expect(mail.from).to eq ['notifications@portfoliorrr.com']
      expect(mail.body).to include "Você recebeu um convite para participar do projeto #{invitation.project_title}."
    end
  end
end
