require 'rails_helper'

RSpec.describe Post, type: :model do
  describe '#valid?' do
    context 'presença' do
      it 'deve ter um título' do
        post = build(:post, title: '')

        expect(post.valid?).to eq false
      end

      it 'deve ter um conteúdo' do
        post = build(:post, content: '')

        expect(post.valid?).to eq false
      end

      it 'deve ter status válido' do
        post = build(:post, status: '')

        expect(post.valid?).to eq false
      end
    end

    context 'data de publicação' do
      it 'não deve ser no passado' do
        user = create(:user)
        post = build(:post, user:, published_at: Time.zone.yesterday, status: :scheduled)

        expect(post).not_to be_valid
        expect(post.errors[:published_at]).to include('não pode estar no passado')
      end
    end
  end

  describe 'self.get_sample' do
    it 'e não retorna publicações com status diferente de published' do
      user = create(:user)
      create(:post, user:)
      create(:post, user:, title: 'Pull Request', content: 'Façam o Pull Request na main antes...')
      create(:post, user:, title: 'Turma 11', content: 'A melhor turma de todas', status: 'draft')

      expect(Post.get_sample(3).count).to eq 2
    end

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

  it 'valor padrão para status deve ser published' do
    post = Post.new

    expect(post.status).to eq 'published'
  end

  describe '#published!' do
    it 'deve alterar status para published e atualizar published_at' do
      post = create(:post, status: 'scheduled', published_at: 1.day.from_now)

      post.published!

      expect(post.reload).to be_published
      expect(post.reload.published_at.to_date).to eq Time.current.to_date
    end
  end
end
