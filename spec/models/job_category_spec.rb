require 'rails_helper'

RSpec.describe JobCategory, type: :model do
  describe '#valid?' do
    it 'nome não pode ficar em branco' do
      job_category = build(:job_category, name: '')

      expect(job_category).not_to be_valid
      expect(job_category.errors[:name]).to include('não pode ficar em branco')
    end

    it 'nome deve ser único' do
      create(:job_category, name: 'Web Design')
      job_category = build(:job_category, name: 'web design')

      expect(job_category).not_to be_valid
      expect(job_category.errors[:name]).to include('já está em uso')
    end
  end

  describe '#destroy' do
    it 'com sucesso' do
      job_category = create(:job_category)

      job_category.destroy

      expect(JobCategory.count).to eq 0
    end

    it 'retorna false se a categoria de trabalho estiver sendo utilizada' do
      job_category = create(:job_category)
      user = create(:user)
      create(:profile_job_category,
             job_category:,
             profile: user.profile,
             description: 'Experiência com Web Design')

      expect(job_category.destroy).to be false
      expect(JobCategory.count).to eq 1
      expect(job_category.errors[:base]).to include('Não é possível excluir o registro pois existem perfis dependentes')
    end
  end
end
