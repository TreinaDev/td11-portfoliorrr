FactoryBot.define do
  factory :invitation_request do
    profile
    message { 'Me convida ai' }
    project_id { 1 }
    email { Faker::Internet.email }
  end
end
