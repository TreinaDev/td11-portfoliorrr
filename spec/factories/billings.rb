FactoryBot.define do
  factory :billing do
    subscription { nil }
    billing_date { '2024-02-15' }
    amount { '19.90' }
  end
end
