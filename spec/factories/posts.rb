FactoryBot.define do
  factory :post do
    user
    title { 'Tenho Opiniões' }
    content { 'E não são poucas' }
    edited_at { Time.zone.now }
  end
end
