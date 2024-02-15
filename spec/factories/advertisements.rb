FactoryBot.define do
  factory :advertisement do
    image { nil }
    link { "MyString" }
    display_time { 1 }
    view_count { 1 }
    title { "MyString" }
    user { nil }
  end
end
