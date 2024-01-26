require 'rails_helper'

RSpec.describe ProfessionalInfo, type: :model do
  describe '#valid?' do
    it 'Empresa não pode ficar em branco' do
      professional_info = build(:professional_info, company: '')

      expect(professional_info).not_to be_valid
      expect(professional_info.errors[:company]).to include('não pode ficar em branco')
    end

    it 'Cargo não pode ficar em branco' do
      professional_info = build(:professional_info, position: '')

      expect(professional_info).not_to be_valid
      expect(professional_info.errors[:position]).to include('não pode ficar em branco')
    end
    it 'Data de entrada não pode ficar em branco' do
      professional_info = build(:professional_info, start_date: '')

      expect(professional_info).not_to be_valid
      expect(professional_info.errors[:start_date]).to include('não pode ficar em branco')
    end
    it 'Data de saída não pode ficar em branco' do
      professional_info = build(:professional_info, current_job: false, end_date: '')

      expect(professional_info).not_to be_valid
      expect(professional_info.errors[:end_date]).to include('não pode ficar em branco')
    end
  end
end
