FactoryBot.define do
  factory :like do
    user

    trait :for_post do
      association :likeable, factory: :post
    end

    trait :for_comment do
      association :likeable, factory: :comment
    end

    trait :for_reply do
      association :likeable, factory: :reply
    end
  end
end
