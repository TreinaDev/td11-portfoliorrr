require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'self.get_sample' do
    it 'e retorna a quantidade esperada de publicações' do
      user = create(:user)

      create(:post, user:)
      create(:post, user:, title: 'Turma 11', content: 'A melhor turma de todas')
      create(:post, user:, title: 'Pull Request', content: 'Façam o Pull Request na main antes...')

      expect(Post.get_sample(2).count).to eq 2
      expect(Post.get_sample(5).count).to eq 3
    end
  end
  describe '#pinned' do
    it 'e não altera o edited_at' do
      user = create(:user)
      post = create(:post, user:, title: 'Post A', content: 'Primeira postagem')

      post.pinned!

      expect(post.edited_at.to_date).to eq post.created_at.to_date
    end
  end
end
