FactoryBot.define do
  factory :education_info do
    institution { 'UFJF' }
    course { 'Bacharelado em Ciência da Computação' }
    start_date { '2012-12-25' }
    end_date { '2015-12-31' }
    visibility { true }
    profile

    trait :faked do
      institution { "Universidade #{Faker::Space.planet}" }
      course { "Tecnólogo em #{Faker::Sport.sport}" }
    end

    trait :first_seed do
      institution { "Universidade #{Faker::Address.city} #{Faker::Space.planet}" }
      course { "#{Faker::Job.education_level} em #{Faker::Job.course}" }
      start_date { Faker::Date.backward(days: Time.zone.today - profile.personal_info.birth_date + 7000) }
      end_date { Faker::Date.between(from: start_date, to: start_date.advance(months: rand(2..120))) }
    end

    trait :seed do
      institution { "Universidade #{Faker::Address.city} #{Faker::Space.planet}" }
      course { "#{Faker::Job.education_level} em #{Faker::Job.course}" }
      start_date do
        Faker::Date.between(from: profile.education_infos.last.end_date,
                            to: profile.education_infos.last.end_date.advance(months: rand(2..12)))
      end
      end_date { Faker::Date.between(from: start_date, to: start_date.advance(months: rand(2..120))) }
    end
  end
end
