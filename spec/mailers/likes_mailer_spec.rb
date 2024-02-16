require 'rails_helper'

RSpec.describe LikesMailer, type: :mailer do
  context '#notify_like' do
    it 'envia e-mail para usuário com resumo das curtidas diárias' do
      # arrange
      user = create(:user)
      post_a = create(:post, user:)
      post_b = create(:post, user:)
      comment = create(:comment, user:)
      create(:like, likeable: post_a)
      create(:like, likeable: post_b)
      create(:like, likeable: comment)

      travel_to(2.days.ago) do
        10.times { create(:like, likeable: post_a) }
      end
      # act
      mail = LikesMailer.with(user:).notify_like
      # expect
      expect(mail.subject).to eq 'Você recebeu 3 curtidas nas últimas 24 horas!'
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
      expect(mail.body).to have_link 'Clique aqui', href: profile_url(user.profile.slug)
      expect(mail.body).to include 'para acessar seu perfil e continuar interagindo.'
    end

    it 'oculta informações sobre comentários se não houverem curtidas em comentários' do
      # arrange
      user = create(:user)
      post = create(:post, user:)
      comment = create(:comment, user:)
      3.times { create(:like, likeable: post) }
      # act
      mail = LikesMailer.with(user:).notify_like
      # expect
      expect(mail.body).to include "Olá, #{user.full_name}"
      expect(mail.body).to include 'Seu perfil andou movimentado:'
      expect(mail.body).to include 'Você recebeu 3 curtidas em seus posts'
      expect(mail.body).not_to include 'Você recebeu 0 curtidas em seus comentários'
      expect(mail.body).to include "A publicação mais curtida foi <a href=\"#{post_url(post)}\">#{post.title}</a>"
      expect(mail.body).not_to include "O seu comentário mais curtido foi #{comment.message} na publicação "
      expect(mail.body).not_to include "<a href=\"#{post_url(comment.post)}\">#{comment.post.title}</a>"
      expect(mail.body).to have_link 'Clique aqui', href: profile_url(user.profile.slug)
      expect(mail.body).to include 'para acessar seu perfil e continuar interagindo.'
    end

    it 'oculta informações sobre publicações se não houverem curtidas em publicações' do
      user = create(:user)
      post = create(:post, user:)
      comment = create(:comment, user:)
      3.times { create(:like, likeable: comment) }

      mail = LikesMailer.with(user:).notify_like

      expect(mail.body).to include "Olá, #{user.full_name}"
      expect(mail.body).to include 'Seu perfil andou movimentado:'
      expect(mail.body).not_to include 'Você recebeu 0 curtidas em seus posts'
      expect(mail.body).to include 'Você recebeu 3 curtidas em seus comentários'
      expect(mail.body).not_to include "A publicação mais curtida foi <a href=\"#{post_url(post)}\">#{post.title}</a>"
      expect(mail.body).to include "O seu comentário mais curtido foi #{comment.message} na publicação "
      expect(mail.body).to include "<a href=\"#{post_url(comment.post)}\">#{comment.post.title}</a>"
      expect(mail.body).to have_link 'Clique aqui', href: profile_url(user.profile.slug)
      expect(mail.body).to include 'para acessar seu perfil e continuar interagindo.'
    end
  end
end
