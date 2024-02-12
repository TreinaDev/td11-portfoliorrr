class SeedHelper # rubocop:disable Metrics/ClassLength
  require 'factory_bot_rails'
  require 'faker'
  Faker::Config.locale = :'pt-BR'
  Faker::UniqueGenerator.clear

  def super_seed(number_of_users = 10, min = 2, max = 7) # rubocop:disable Metrics/MethodLength
    seed_images_for_posts
    seed_users(number_of_users)
    seed_professional_infos(min, max)
    seed_education_infos(min, max)
    seed_job_categories
    seed_profile_job_categories(min, max)
    create_tag_combos
    seed_image_post
    seed_text_posts(min, max)
    seed_followers(min, max)
    seed_comments(min, max)
    seed_post_likes(min, max)
    seed_comment_likes(min, max)
  end

  def seed_images_for_posts
    @images_for_posts = [
      ActiveStorage::Blob.create_and_upload!(
        io: File.open(Rails.root.join('app', 'assets', 'images', 'seeds', 'turma_11.jpeg')), filename: 'turma11.jpeg'
      ), ActiveStorage::Blob.create_and_upload!(
        io: File.open(Rails.root.join('app', 'assets', 'images', 'seeds', 'git_github.jpg')), filename: 'git_github.jpg'
      ), ActiveStorage::Blob.create_and_upload!(
        io: File.open(Rails.root.join('app', 'assets', 'images', 'seeds', 'vue_js.jpg')), filename: 'vue_js.jpg'
      )
    ]
  end

  def seed_users(number)
    number.times do
      # Cadastra usuário com perfil e informações pessoais
      user = FactoryBot.create(:user, :seed)
      profile = FactoryBot.create(:profile, :seed, user:)
      FactoryBot.create(:personal_info, :seed, profile:)
    end
  end

  def seed_professional_infos(min, max)
    FactoryBot.create(:professional_info, :first_seed, profile:)
    rand(min..max).times do
      FactoryBot.create(:professional_info, :seed, profile:)
    end
  end

  def seed_education_infos(min, max)
    FactoryBot.create(:education_info, :first_seed, profile:)
    rand(min..max).times do
      FactoryBot.create(:education_info, :seed, profile:)
    end
  end

  def seed_profile_job_categories(min, max)
    rand(2..7).times do
      repeated_job_category = profile.profile_job_categories.pluck(:job_category_id)
      job_categories = JobCategory.all.reject { |job_category| repeated_job_category.include?(job_category.id) }
      FactoryBot.create(:profile_job_category,
                        profile:,
                        job_category: job_categories.sample,
                        description: Faker::Lorem.paragraph)
    end
  end

  def seed_image_post
    html_post = %(<action-text-attachment sgid="#{@images_for_posts.sample.attachable_sgid}"></action-text-attachment>)
    user.posts.create(title: Faker::Lorem.sentence, content: "#{Faker::Lorem.paragraph} #{html_post}",
                      tag_list: [tags].sample)
  end

  def seed_text_posts(min, max)
    rand(min..max).times do
      user.posts.create(title: Faker::Lorem.sentence, content: Faker::Lorem.paragraph, tag_list: [tags].sample)
    end
  end

  def seed_followers(min, max)
    User.all.find_each do |user|
      rand(min..max).times do
        not_followed_profiles = Profile.all.reject { |profile| profile.following?(user.profile) }
        followed_profile = not_followed_profiles.sample if not_followed_profiles.any?
        Connection.create!(follower: user.profile, followed_profile:) unless followed_profile == user.profile
      end
    end
  end

  def seed_comments(min, max)
    Post.all.find_each do |post|
      rand(min..max).times do
        FactoryBot.create(:comment, :seed, post:, user: User.all.sample)
      end
    end
  end

  def seed_post_likes(min, max)
    Post.all.find_each do |post|
      rand(min..max).times do
        likeing_user = User.all.reject { |user| comment.likes.pluck(:user_id).include?(user.id) }.sample
        FactoryBot.create(:like, :for_post, likeable: post, user: likeing_user)
      end
    end
  end

  def seed_comment_likes(min, max)
    Comment.all.find_each do |post|
      rand(min..max).times do
        likeing_user = User.all.reject { |user| comment.likes.pluck(:user_id).include?(user.id) }.sample
        FactoryBot.create(:like, :for_comment, likeable: comment, user: likeing_user)
      end
    end
  end

  def seed_job_categories
    [
      'Trabalho em equipe', 'Comunicação', 'Resolução de problemas', 'Liderança', 'Organização',
      'Trabalhar sobre pressão', 'Confiança', 'Auto motivado', 'Habilidades de networking', 'Proatividade',
      'Aprendizado rápido', 'Experiência com tecnologia', 'Desenvolvimento Web', 'Programação em Ruby',
      'HTML', 'CSS', 'JavaScript', 'Resolução de Problemas', 'Comunicação Efetiva', 'Colaboração em Equipe',
      'Resiliência', 'Gestão do Tempo', 'Gestão de Projetos', 'Experiência do Usuário (UX)', 'SEO',
      'Análise de Dados', 'Redes Sociais', 'Marketing Digital', 'Liderança', 'Trabalho Remoto', 'Ruby on Rails'
    ].each { |name| JobCategory.create(name:) }
  end

  def create_tag_combos
    @tags = [
      %w[tdd rubocop], %w[seeds desafios], %w[boaspraticas solid], %w[vue zoom], %w[vue desafios],
      %w[codesaga desafios tdd], %w[rubocop vue seeds], %w[zoom boaspraticas solid],
      %w[tdd codesaga], %w[rubocop vue desafios], %w[seeds boaspraticas zoom], %w[solid codesaga]
    ]
  end
end
