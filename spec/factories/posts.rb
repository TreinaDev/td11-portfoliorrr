FactoryBot.define do
  factory :post do
    user
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph sentence_count: 35 }
    edited_at { Time.zone.now }
  end
end
