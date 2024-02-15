FactoryBot.define do
  factory :billing do
    amount { 19.901 }
    subscription { nil }
    billing_date { '2024-02-14' }
  end
end
