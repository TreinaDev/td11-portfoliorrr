FactoryBot.define do
  factory :comment do
    message { 'Um comentário legal' }
    post
    user

    trait :seed do
      message { Faker::Lorem.paragraph }
    end
  end
end
