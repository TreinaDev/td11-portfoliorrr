require 'rails_helper'

RSpec.describe NotificationStrategy, type: :model do
  describe '#redirect_after_click' do
    it 'retorna um convite' do
      invitation = create(:invitation)
      notification = create(:notification, notifiable: invitation)
      strategy = NotificationStrategy.new(notification)

      expect(strategy.redirect_after_click).to eq(invitation)
    end

    context 'retorna um post' do
      it 'se a notificação for de um post' do
        post = create(:post)
        notification = create(:notification, notifiable: post)
        strategy = NotificationStrategy.new(notification)

        expect(strategy.redirect_after_click).to eq(post)
      end

      it 'se a notificação for de um comentário' do
        comment = create(:comment)
        notification = create(:notification, notifiable: comment)
        strategy = NotificationStrategy.new(notification)

        expect(strategy.redirect_after_click).to eq(comment.post)
      end

      it 'se a notificação for de um like' do
        like = create(:like, :for_post)
        notification = create(:notification, notifiable: like)

        NotificationStrategy.new(notification)

        connection = create(:connection)
        notification = create(:notification, notifiable: connection)
        strategy = NotificationStrategy.new(notification)

        expect(strategy.redirect_after_click).to eq(connection.follower)
      end
    end

    it 'retorna um seguidor' do
      connection = create(:connection)
      notification = create(:notification, notifiable: connection)
      strategy = NotificationStrategy.new(notification)

      expect(strategy.redirect_after_click).to eq(connection.follower)
    end
  end
end
