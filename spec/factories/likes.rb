FactoryBot.define do
  factory :like do
    user

    trait :for_post do
      association :likeable, factory: :post
    end

    trait :for_comment do
      association :likeable, factory: :comment
    end
  end
end
