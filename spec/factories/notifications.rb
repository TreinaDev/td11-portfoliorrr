FactoryBot.define do
  factory :notification do
    profile
    read { false }

    trait :for_post do
      association :notifiable, factory: :post
    end

    trait :for_comment do
      association :notifiable, factory: :comment
    end

    trait :for_like do
      association :notifiable, factory: :like
    end
  end
end
