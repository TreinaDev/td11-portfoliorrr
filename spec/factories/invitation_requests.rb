FactoryBot.define do
  factory :invitation_request do
    profile
    message { 'Me convida ai' }
    project_id { 1 }
  end
end
