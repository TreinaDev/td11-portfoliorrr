FactoryBot.define do
  factory :subscription do
    user
    start_date { Time.zone.now.to_date }
    status { 0 }
  end
end
