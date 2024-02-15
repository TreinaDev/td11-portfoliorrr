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

    trait :first_job do
      company { Faker::Company.name }
      position { Faker::Job.position }
      description { Faker::Lorem.sentences(number: 6) }
      profile
      start_date { Faker::Date.backward(days: Time.zone.today - profile.personal_info.birth_date + 5840) }
      end_date { Faker::Date.between(from: start_date, to: start_date.advance(months: rand(2..120))) }
    end

    trait :seed_job do
      company { Faker::Company.name }
      position { Faker::Job.position }
      description { Faker::Lorem.sentences(number: 6) }
      start_date do
        Faker::Date.between(from: profile.professional_infos.last.end_date,
                            to: profile.professional_infos.last.end_date.advance(months: rand(2..12)))
      end
      end_date { Faker::Date.between(from: start_date, to: start_date.advance(months: rand(2..120))) }
    end

    trait :current_job do
      company { Faker::Company.name }
      position { Faker::Job.position }
      description { Faker::Lorem.sentences(number: 6) }
      profile
      start_date { Faker::Date.backward(days: Time.zone.today - profile.personal_info.birth_date + 5840) }
      end_date {}
      current_job { true }
    end
  end
end
