require 'factory_bot_rails'
require 'faker'
Faker::Config.locale = :'pt-BR'
Faker::UniqueGenerator.clear

# Cria admin
admin = FactoryBot.create(:user, full_name: 'Boninho da Globo', email: 'admin@admin.com', password: '654321', role: 'admin')

# Cria 40 usuários e pra cada um cria:
# rand(2..7) experiências de trabalho
# rand(2..7) experiências acadêmicas
# rand(2..7) categorias de trabalho com descrição
# 1 post com imagem
# rand(1..3) posts somente texto
# rand(2..5) seguidores
# rand(0..10) comentários por posts
# rand(0..10) likes em posts
# rand(0..10) likes em comentários


# Setup
@number_of_users = 20


# 30 categorias de Trabalho
[
  'Trabalho em equipe', 'Comunicação', 'Resolução de problemas', 'Liderança', 'Organização',
  'Trabalhar sobre pressão', 'Confiança', 'Auto motivado', 'Habilidades de networking', 'Proatividade',
  'Aprendizado rápido', 'Experiência com tecnologia', 'Desenvolvimento Web', 'Programação em Ruby',
  'HTML', 'CSS', 'JavaScript', 'Resolução de Problemas', 'Comunicação Efetiva', 'Colaboração em Equipe',
  'Resiliência', 'Gestão do Tempo', 'Gestão de Projetos', 'Experiência do Usuário (UX)', 'SEO',
  'Análise de Dados', 'Redes Sociais', 'Marketing Digital', 'Liderança', 'Trabalho Remoto', 'Ruby on Rails'
].each { |name| JobCategory.create(name:) }

# 12 combinações de tags para posts
tags = [
         ['tdd', 'rubocop'], ['seeds', 'desafios'], ['boaspraticas', 'solid'], ['vue', 'zoom'], ["vue", "desafios"],
         ['codesaga', 'desafios', 'tdd'], ['rubocop', 'vue', 'seeds'], ['zoom', 'boaspraticas', 'solid'],
         ["tdd", "codesaga"], ["rubocop", "vue", "desafios"], ["seeds", "boaspraticas", "zoom"], ["solid", "codesaga"]
]

# 3 imagens para posts WIP
images_for_posts = [
  ActiveStorage::Blob.create_and_upload!(
    io: File.open(Rails.root.join('app', 'assets', 'images', 'seeds',
                                  'turma_11.jpeg')),
                                  filename: 'turma11.jpeg'
  ),
  ActiveStorage::Blob.create_and_upload!(
    io: File.open(Rails.root.join('app', 'assets', 'images', 'seeds',
                                  'git_github.jpg')),
                                  filename: 'git_github.jpg'
  ),ActiveStorage::Blob.create_and_upload!(
    io: File.open(Rails.root.join('app', 'assets', 'images', 'seeds',
                                  'vue_js.jpg')),
                                  filename: 'vue_js.jpg'
  )
]

# Adiciona usuários, perfis, informações pessoais
print "\n4. criando usuários "
@number_of_users.times do
  user = FactoryBot.create(:user, :seed)
  profile = FactoryBot.create(:profile, :seed, user:)
  profile.photo.attach(Rails.root.join('app', 'assets', 'images', 'avatars', "avatar#{user.id}.png"))
  personal_info = FactoryBot.create(:personal_info, :seed, profile:)

  # Adiciona experiências profissionais
  FactoryBot.create(:professional_info, :first_job, profile:)
  rand(2..7).times do
    FactoryBot.create(:professional_info, :seed_job, profile:)
  end
  FactoryBot.create(:professional_info, :current_job, profile:)

  # Adiciona experiências acadêmicas
  FactoryBot.create(:education_info, :first_seed, profile:)
  rand(2..7).times do
    FactoryBot.create(:education_info, :seed, profile:)
  end

  # Cadastra e escreve descrição de categorias de trabalho
  rand(2..7).times do
    repeated_job_category = profile.profile_job_categories.pluck(:job_category_id)
    job_categories = JobCategory.all.reject { |job_category| repeated_job_category.include?(job_category.id) }
    FactoryBot.create(:profile_job_category,
                      profile:,
                      job_category: job_categories.sample,
                      description: Faker::Lorem.paragraph)
  end
  print '.'
end

# Para cada user cria um post com imagem e de um a três sem imagens
print "\n3. criando postagens "
User.all.each do |user|
  html_post = %(<action-text-attachment sgid="#{images_for_posts.sample.attachable_sgid}"></action-text-attachment>)
  FactoryBot.create(:post, :seed, user:, content: "#{Faker::Lorem.paragraphs(number: 3).join(' ')} #{html_post}")
  rand(1..3).times do
    FactoryBot.create(:post, :seed, user:)
  end
  print '.'
end

# Adiciona followers aos perfis
print "\n2. estabelecendo seguidores e seguidos "
User.all.each do |user|
  rand(2..5).times do
    not_followed_profiles = Profile.all.reject { |profile| profile.following?(user.profile) }
    followed_profile = not_followed_profiles.sample if not_followed_profiles.any?
    Connection.create!(follower: user.profile, followed_profile:) unless followed_profile == user.profile
  end
  print '.'
end

# Adiciona comentários e likes
print "\n1. criando comentários e dando likes "
Post.all.each do |post|
  rand(0..10).times do
    FactoryBot.create(:like, likeable: post, user:  User.all.reject { |user| post.likes.pluck(:user_id).include?(user.id) }.sample)
  end
  rand(0..10).times do
    comment = FactoryBot.create(:comment, :seed, post:, user: User.all.sample)
    rand(0..10).times do
      FactoryBot.create(:like, likeable: comment, user: User.all.reject { |user| comment.likes.pluck(:user_id).include?(user.id) }.sample)
    end
  end
  print '.'
end

puts "\nPronto! #{@number_of_users} usuários criados."
puts "Admin: #{admin.email}, senha: #{admin.password}"
puts "\n"
