require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe '#valid?' do
    it 'deve ter uma mensagem' do
      comment = Comment.new
      comment.valid?
      expect(comment.errors[:message]).to include('não pode ficar em branco')
    end
  end

  describe '#create_notification' do
    it 'cria notificação para o dono da publicação' do
      user = create(:user)
      other_user = create(:user)
      post = create(:post, user:)
      comment = create(:comment, user: other_user, post:)

      expect(Notification.count).to eq 1
      expect(Notification.last.notifiable).to eq comment
    end

    it 'não cria notificação para o dono do comentário' do
      user = create(:user)
      post = create(:post, user:)
      create(:comment, user:, post:)

      expect(Notification.count).to eq 0
    end
  end
end
