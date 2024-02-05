FactoryBot.define do
  factory :job_category do
    sequence(:name) { |n| "Web Design#{n}" }
  end
end
