require 'rails_helper'

RSpec.describe Advertisement, type: :model do
  describe '#valid?' do
    it 'Deve ter título' do
      advertisement = Advertisement.new
      advertisement.valid?
      expect(advertisement.errors[:title]).to include('não pode ficar em branco')
    end

    context 'Formato do link' do
      it 'Deve ter link' do
        advertisement = Advertisement.new
        advertisement.valid?
        expect(advertisement.errors[:link]).to include('não pode ficar em branco')
      end

      it 'deve ser válido com formato correto' do
        user = create(:user)
        ad = Advertisement.new(title: 'Venha ser Dev', user:, link: 'https://www.campuscode.com')
        expect(ad).to be_valid
      end

      it 'deve ser inválido com formato incorreto' do
        user = create(:user)
        ad = Advertisement.new(title: 'Venha ser Dev', user:, link: 'campus##code.com')
        expect(ad).not_to be_valid
      end
    end
  end

  describe '#displayed' do
    it 'deve retornar apenas anúncios não expirados' do
      create(:advertisement, created_at: 6.days.ago, display_time: 7)

      ads = Advertisement.displayed

      expect(ads.size).to eq 1
    end

    it 'não deve retornar anúncios expirados' do
      create(:advertisement, created_at: 2.days.ago, display_time: 1)

      ads = Advertisement.displayed

      expect(ads.size).to eq 0
    end
  end
end
