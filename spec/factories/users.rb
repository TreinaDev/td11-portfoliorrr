FactoryBot.define do
  factory :user do
    full_name { 'Joao Almeida' }
    citizen_id_number { '92767398078' }
    sequence(:email) { |n| "joao#{n}@email.com" }
    password { '123456' }
  end
end
