FactoryBot.define do
  factory :user do
    full_name { Faker::Name.name }
    citizen_id_number { Faker::IDNumber.brazilian_citizen_number }
    email { Faker::Internet.email }
    password { '123456' }

    trait :seed do
      after(:build) do |user|
        user.class.skip_callback(:create, :after, :create_profile!, raise: false)
      end
    end

    trait :free do
      after(:create) do |user|
        user.subscription.inactive!
      end
    end

    trait :paid do
      after(:create) do |user|
        user.subscription.active!
      end
    end
  end
end
