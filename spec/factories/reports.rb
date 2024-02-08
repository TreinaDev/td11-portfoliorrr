FactoryBot.define do
  factory :report do
    profile

    trait :for_profile do
      association :reportable, factory: :profile
    end

    trait :for_post do
      association :reportable, factory: :post
    end

    trait :for_comment do
      association :reportable, factory: :comment
    end

    message { Faker::Lorem.paragraph }
    status { 0 }
    offence_type {
      [
        'Discurso de ódio',
        'Pornografia',
        'Racismo',
        'Spam',
        'Conteúdo pertubador',
        'Abuso/Perseguição'
      ].sample
     }
  end
end
