require 'rails_helper'

RSpec.describe Like, type: :model do
  describe '#valid?' do
    it 'deve ser única por usuario e likeable' do
      user = create(:user)
      post = create(:post)
      create(:like, user:, likeable: post)

      like = Like.new(user:, likeable: post)

      expect(like).not_to be_valid
      expect(like.errors[:likeable_id]).to include('já está em uso')
    end

    it 'usuário pode ter vários likeables' do
      user = create(:user)
      post = create(:post, user:)
      other_post = create(:post, user:)
      comment = create(:comment, user:)

      create(:like, user:, likeable: post)
      create(:like, user:, likeable: other_post)

      like = Like.new(user:, likeable: comment)

      expect(like).to be_valid
    end

    it 'likeable pode ter vários usuários' do
      user = create(:user)
      other_user = create(:user, email: 'email@email.com', citizen_id_number: '88393983096')
      post = create(:post, user:)

      create(:like, user:, likeable: post)
      like = Like.new(user: other_user, likeable: post)

      expect(like).to be_valid
    end
  end

  describe '#create_notification' do
    it 'cria notificação para o dono da publicação' do
      user = create(:user)
      other_user = create(:user)
      post = create(:post, user:)
      like = create(:like, likeable: post, user: other_user)

      expect(Notification.count).to eq 1
      expect(Notification.last.notifiable).to eq like
    end

    it 'não cria notificação para o dono do like' do
      user = create(:user)
      post = create(:post, user:)
      create(:like, likeable: post, user:)

      expect(Notification.count).to eq 0
    end
  end
end
