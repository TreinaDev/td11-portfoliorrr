FactoryBot.define do
  factory :comment do
    message { 'Um comentário legal' }
    post
    user
  end
end
