FactoryBot.define do
  factory :professional_info do
    company { 'Campus Code' }
    position { 'Desenvolvedor Ruby on Rails' }
    start_date { '2022-01-23' }
    end_date { '2024-01-23' }
    visibility { true }
    profile

    trait :faked do
      company { Faker::TvShows::RuPaul.queen }
      position { %w[programador estagiário gerente].sample }
    end
  end
end
