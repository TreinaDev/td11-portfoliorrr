require 'cpf_cnpj'

FactoryBot.define do
  factory :user do
    full_name { 'Joao Almeida' }
    citizen_id_number { CPF.generate }
    sequence(:email) { |n| "joao#{n}@email.com" }
    password { '123456' }
  end
end
