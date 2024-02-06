require 'rails_helper'

RSpec.describe NotificationsMailer, type: :mailer do
  context 'notify' do
    it 'envia email de notificação após um like num post' do
      author = create(:user)
      user = create(:user, full_name: 'Rosemilson Barbosa')
      post = create(:post, user: author, title: 'Olá, mundo', content: 'Esse é meu primeiro post')
      like = create(:like, user:, likeable: post)

      mail = NotificationsMailer.with(notification: like.notification).notify_like

      expect(mail.subject).to include 'Alguém curtiu seu post'
      expect(mail.to).to eq [author.email]
      expect(mail.from).to eq ['notifications@portfoliorrr.com']
      expect(mail.body).to include 'Rosemilson Barbosa curtiu seu post'
      expect(mail.body).to include 'Olá, mundo'
      expect(mail.body).to include 'Esse é meu primeiro post'
    end
  end
end
