FactoryBot.define do
  factory :subscription do
    user
    start_date { '2024-02-15' }
    status { 0 }
  end
end
