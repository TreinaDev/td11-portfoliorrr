require 'rails_helper'

RSpec.describe LikesMailer, type: :mailer do
  context '#notify_like' do
    it 'envia e-mail para autor da publicação curtida' do
      # arrange
      like = create(:like, :for_post)
      # act
      mail = LikesMailer.with(like:).notify_like
      # expect
      expect(mail.subject).to eq "Curtiram sua publicação #{like.likeable.title}"
      expect(mail.to).to eq [like.likeable.user.email]
      expect(mail.from).to eq ['no-reply@portfoliorrr.com']
    end

    it 'com texto descritivo no corpo do email' do
      # arrange
      like = create(:like, :for_post)
      # act
      mail = LikesMailer.with(like:).notify_like
      # expect
      expect(mail.body).to include "Olá, #{like.likeable.user.full_name}"
      expect(mail.body.encoded).to have_link 'sua publicação', href: post_url(like.likeable)
      expect(mail.body.encoded).to have_link like.user.full_name, href: profile_url(like.user.profile)
    end

    it 'envia e-mail para autor do comentário curtido' do
      # arrange
      like = create(:like, :for_comment)
      # act
      mail = LikesMailer.with(like:).notify_like
      # expect
      expect(mail.subject).to eq "Curtiram seu comentário na publicação #{like.likeable.post.title}"
      expect(mail.to).to eq [like.likeable.user.email]
      expect(mail.from).to eq ['no-reply@portfoliorrr.com']
    end

    pending 'não envia e-mail em caso de autocurtida de publicação'
    pending 'não envia e-mail em caso de autocurtida de comentário'
    pending 'não envia e-mail caso o mesmo usuário curta publicação 2x ou mais em menos de 10 minutos'
    pending 'não envia e-mail caso o mesmo usuário curta comentário 2x ou mais em menos de 10 minutos'
  end
end
