FactoryBot.define do
  factory :billing do
    amount { "9.99" }
    subscription { nil }
    billing_date { "2024-02-14" }
  end
end
