FactoryBot.define do
  factory :profile_job_category do
    profile
    job_category
    sequence(:description) { |n| "Formação completa com #{n} ano de experiencia" }
  end
end
