require 'rails_helper'

RSpec.describe JobCategory, type: :model do
  describe '#valid?' do
    it 'nome não pode ficar em branco' do
      job_category = build(:job_category, name: '')

      result = job_category.valid?

      expect(result).to be false
      expect(job_category.errors[:name]).to include('não pode ficar em branco')
    end

    it 'nome deve ser único' do
      create(:job_category, name: 'Web Design')
      job_category = build(:job_category, name: 'web design')

      result = job_category.valid?

      expect(result).to be false
      expect(job_category.errors[:name]).to include('já está em uso')
    end
  end
end
