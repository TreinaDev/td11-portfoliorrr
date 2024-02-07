require 'rails_helper'

RSpec.describe ConnectionsMailer, type: :mailer do
  context '#notify_follow' do
    it 'envia email de notificação após um follow num post' do
      follower = create(:user, full_name: 'Danilo Martins')
      followed_profile = create(:user, full_name: 'Rosemilson Barbosa')
      connection = Connection.create!(follower: follower.profile,
                                      followed_profile: followed_profile.profile,
                                      status: 'active')

      mail = ConnectionsMailer.with(notification: connection.notification).notify_follow

      expect(mail.subject).to include 'Alguém seguiu seu perfil'
      expect(mail.to).to eq [followed_profile.email]
      expect(mail.from).to eq ['notifications@portfoliorrr.com']
      expect(mail.body).to include 'Danilo Martins te seguiu'
    end
  end
end
