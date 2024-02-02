FactoryBot.define do
  factory :invitation do
    profile
    project_title { 'Projeto Cola?Bora!' }
    project_description { 'Um projeto muito legal' }
    project_category { 'Ruby on Rails' }
    colabora_invitation_id { 1 }
    message { 'Venha participar do projeto!' }
    expiration_date { 1.week.from_now.to_date }
    status { 0 }
  end
end
