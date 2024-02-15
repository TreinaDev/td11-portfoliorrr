FactoryBot.define do
  factory :subscription do
    user { nil }
    status { 0 }
    start_date { '2024-02-15' }
  end
end
