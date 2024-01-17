FactoryBot.define do
  factory :user do
    email { 'joao@almeida.com' }
    password { '123456' }
    role { :user }

    trait :admin do
      role { :admin }
    end
  end
end
