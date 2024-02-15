require 'rails_helper'

RSpec.describe Reply, type: :model do
  describe '#valid?' do
    it 'mensagem em branco' do
      reply = build(:reply, message: '')

      expect(reply).not_to be_valid
      expect(reply.errors[:message]).to include 'não pode ficar em branco'
    end
  end
end
