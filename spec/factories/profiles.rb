FactoryBot.define do
  factory :profile do
    user
    cover_letter { 'Sou profissional organizado, esforçado e apaixonado pelo que faço' }
  end

  trait :seed do
    cover_letter { Faker::Marketing.buzzwords }
    after(:build) do |profile|
      profile.class.skip_callback(:create, :after, :create_personal_info!, raise: false)
    end
  end
end
