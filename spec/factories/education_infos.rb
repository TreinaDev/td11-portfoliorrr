FactoryBot.define do
  factory :education_info do
    institution { 'UFJF' }
    course { 'Bacharelado em Ciência da Computação' }
    start_date { '2012-12-25' }
    end_date { '2015-12-31' }
    visibility { true }
    profile
  end
end
