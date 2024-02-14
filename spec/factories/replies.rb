FactoryBot.define do
  factory :reply do
    user
    comment
    message { 'Não gostei do seu comentário' }
  end
end
