FactoryBot.define do
  factory :subscription do
    user { nil }
    start_date { '2024-02-14' }
    status { 10 }
  end
end
