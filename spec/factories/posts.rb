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
      content { 
                [
                  Faker::Lorem.paragraph(sentence_count: rand(4..18)),
                  Faker::Lorem.paragraph(sentence_count: rand(2..18)),
                  Faker::Lorem.paragraph(sentence_count: rand(4..18)),
                  Faker::Lorem.paragraph(sentence_count: rand(4..18)),
                  Faker::Lorem.paragraph(sentence_count: rand(4..18))
                ].join('<br><br>')
              }
      tag_list {
                 [
                   ['tdd', 'rubocop'], ['seeds', 'desafios'], ['boaspraticas', 'solid'], ['vue', 'zoom'], ["vue", "desafios"],
                   ['codesaga', 'desafios', 'tdd'], ['rubocop', 'vue', 'seeds'], ['zoom', 'boaspraticas', 'solid'],
                   ["tdd", "codesaga"], ["rubocop", "vue", "desafios"], ["seeds", "boaspraticas", "zoom"], ["solid", "codesaga"]
                 ].sample
               }
    end
  end
end
