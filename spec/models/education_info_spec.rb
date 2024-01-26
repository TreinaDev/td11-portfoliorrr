require 'rails_helper'

RSpec.describe EducationInfo, type: :model do
  describe '#valid?' do
    it 'Instituição não pode ficar em branco' do
      education_info = build(:education_info, institution: '')

      expect(education_info).not_to be_valid
      expect(education_info.errors[:institution]).to include('não pode ficar em branco')
    end

    it 'Curso não pode ficar em branco' do
      education_info = build(:education_info, course: '')

      expect(education_info).not_to be_valid
      expect(education_info.errors[:course]).to include('não pode ficar em branco')
    end
    it 'Início não pode ficar em branco' do
      education_info = build(:education_info, start_date: '')

      expect(education_info).not_to be_valid
      expect(education_info.errors[:start_date]).to include('não pode ficar em branco')
    end
    it 'Término não pode ficar em branco' do
      education_info = build(:education_info, end_date: '')

      expect(education_info).not_to be_valid
      expect(education_info.errors[:end_date]).to include('não pode ficar em branco')
    end
  end
end
