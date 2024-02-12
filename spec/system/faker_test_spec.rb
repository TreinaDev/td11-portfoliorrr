require 'rails_helper'

describe 'sidão' do
  it 'user factory não cria profile' do
    user = create(:user, :seed)
    expect(user.profile).to eq nil
  end

  it 'profile factory não cria personal_info' do
    user = create(:user, :seed)
    profile = create(:profile, :seed, user:)
    expect(user.profile).to eq profile
    expect(profile.personal_info).to eq nil
  end

  it 'professional info works fine' do
    user = create(:user, :seed)
    profile = create(:profile, :seed, user:)
    create(:personal_info, :seed, profile:)
    create(:professional_info, :first_seed, profile:)
    5.times do
      create(:professional_info, :seed, profile:)
    end
    create(:education_info, :first_seed, profile:)
    3.times do
      create(:education_info, :seed, profile:)
    end
  end
end
