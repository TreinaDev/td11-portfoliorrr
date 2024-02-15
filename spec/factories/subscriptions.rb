FactoryBot.define do
  factory :subscription do
    user
    start_date { nil }
    status { 0 }
  end
end
