FactoryBot.define do
  factory :report do
    message { 'Isso é discurso de ódio' }
    status { 0 }
    offence_type { 'Discurso de ódio' }
  end
end
