require 'rails_helper'

RSpec.describe LikesMailer, type: :mailer do
  context '#notify_like' do
    it 'envia e-mail para usuário com resumo das curtidas diárias' do
      # arrange
      user = create(:user)
      post_a = create(:post, user:)
      post_b = create(:post, user:)
      comment = create(:comment, user:)
      3.times { create(:like, likeable: post_a) }
      5.times { create(:like, likeable: post_b) }
      2.times { create(:like, likeable: comment) }
      # act
      mail = LikesMailer.with(user:).notify_like
      # expect
      expect(mail.subject).to eq 'Você recebeu 10 curtidas nas últimas 24 horas!'
      expect(mail.to).to eq [user.email]
      expect(mail.from).to eq ['no-reply@portfoliorrr.com']
    end

    it 'com texto descritivo no corpo do email' do
      # arrange
      user = create(:user)
      post_a = create(:post, user:)
      post_b = create(:post, user:)
      comment = create(:comment, user:)
      3.times { create(:like, likeable: post_a) }
      5.times { create(:like, likeable: post_b) }
      2.times { create(:like, likeable: comment) }
      # act
      mail = LikesMailer.with(user:).notify_like
      # expect
      expect(mail.body).to include "Olá, #{user.full_name}"
      expect(mail.body).to include 'Seu perfil andou movimentado:'
      expect(mail.body).to include 'Você recebeu 8 curtidas em seus posts'
      expect(mail.body).to include 'Você recebeu 2 curtidas em seus comentários'
      expect(mail.body).to include "A publicação mais curtida foi <a href=\"#{post_url(post_b)}\">#{post_b.title}</a>"
      expect(mail.body).to include "O seu comentário mais curtido foi #{comment.message} na publicação "
      expect(mail.body).to include "<a href=\"#{post_url(comment.post)}\">#{comment.post.title}</a>"
      expect(mail.body).to have_link 'Clique aqui', href: profile_url(user.profile)
      expect(mail.body).to include 'para acessar seu perfil e continuar interagindo.'
    end

    pending 'não envia e-mail em caso de autocurtida de publicação'
    pending 'não envia e-mail em caso de autocurtida de comentário'
    pending 'não envia e-mail caso o mesmo usuário curta publicação 2x ou mais em menos de 10 minutos'
    pending 'não envia e-mail caso o mesmo usuário curta comentário 2x ou mais em menos de 10 minutos'
  end
end
