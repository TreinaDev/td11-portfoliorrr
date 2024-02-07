FactoryBot.define do
  factory :report do
    message { "MyText" }
    status { 1 }
    reporting_profile { nil }
    reportable { nil }
    offence_type { "MyString" }
  end
end
