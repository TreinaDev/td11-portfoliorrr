require 'cpf_cnpj'

FactoryBot.define do
  factory :user do
    full_name { 'Joao Almeida' }
    citizen_id_number { Faker::IDNumber.brazilian_citizen_number }
    email { Faker::Internet.email }
    password { '123456' }
  end
end
