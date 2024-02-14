FactoryBot.define do
  factory :job_category do
    sequence(:name) { |n| "Web Design#{n}" }

    trait :seed do
      name { Faker::Job.unique.key_skills }
    end
  end
end
