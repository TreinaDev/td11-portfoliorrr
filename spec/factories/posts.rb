FactoryBot.define do
  def long_post
    'very big sentence'
  end

  factory :post do
    user
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph sentence_count: rand(2..12) }
    edited_at { Time.zone.now }

    trait :published do
      published_at { Time.zone.now }
      status { :published }
    end

    trait :seed do
      content do
        [
          Faker::Lorem.paragraph(sentence_count: rand(4..18)),
          Faker::Lorem.paragraph(sentence_count: rand(2..18)),
          Faker::Lorem.paragraph(sentence_count: rand(4..18)),
          Faker::Lorem.paragraph(sentence_count: rand(4..18)),
          Faker::Lorem.paragraph(sentence_count: rand(4..18))
        ].join('<br><br>')
      end
      tag_list do
        [
          %w[tdd rubocop], %w[seeds desafios], %w[boaspraticas solid], %w[vue zoom], %w[vue desafios],
          %w[codesaga desafios tdd], %w[rubocop vue seeds], %w[zoom boaspraticas solid],
          %w[tdd codesaga], %w[rubocop vue desafios], %w[seeds boaspraticas zoom], %w[solid codesaga]
        ].sample
      end
    end
  end
end
