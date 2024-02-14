FactoryBot.define do
  factory :personal_info do
    street { 'Avenida Campus Code' }
    street_number { '1200' }
    area { 'TreinaDev' }
    city { 'São Paulo' }
    zip_code { '36200123' }
    state { 'SP' }
    phone { '11999991234' }
    birth_date { '1980-12-25' }
    visibility { true }
    profile

    trait :seed do
      street { Faker::Address.street_name }
      street_number { Faker::Address.building_number }
      area { "#{%w[Vila Jardim].sample} #{Faker::Address.city}" }
      city { Faker::Address.city }
      zip_code { Faker::Address.zip_code }
      state { Faker::Address.state_abbr }
      phone { "#{Faker::PhoneNumber.subscriber_number}#{Faker::PhoneNumber.subscriber_number}" }
      birth_date { Faker::Date.birthday(min_age: 18, max_age: 88) }
      visibility { true }
      profile
    end
  end
end
