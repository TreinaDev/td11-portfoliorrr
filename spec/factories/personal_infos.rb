FactoryBot.define do
  factory :personal_info do
    profile
    street { 'Avenida Campus Code' }
    street_number { '1200' }
    area { 'TreinaDev' }
    city { 'São Paulo' }
    zip_code { '36200123' }
    state { 'SP' }
    phone { '11999991234' }
    birth_date { '1980-12-25' }
    visibility { true }
  end
end
