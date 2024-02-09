FactoryBot.define do
  factory :post do
    user
    title { Faker::Lorem.paragraph }
    content { Faker::Lorem.paragraph sentence_count: 10 }
    edited_at { Time.zone.now }

    trait :published do
      published_at { Time.zone.now }
      status { :published }
    end
  end
end
