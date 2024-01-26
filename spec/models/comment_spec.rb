require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe '#valid?' do
    it 'deve ter uma mensagem' do
      comment = Comment.new
      comment.valid?
      expect(comment.errors[:message]).to include('não pode ficar em branco')
    end
  end
end
