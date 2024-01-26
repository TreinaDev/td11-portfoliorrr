FactoryBot.define do
  factory :professional_info do
    company { 'Campus Code' }
    position { 'Desenvolvedor Ruby on Rails' }
    start_date { '2022-01-23' }
    end_date { '2024-01-23' }
    visibility { true }
    profile
  end
end
