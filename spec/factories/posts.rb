FactoryBot.define do
  factory :post do
    user
    title { 'Tenho Opiniões' }
    content { 'E não são poucas' }
  end
end
