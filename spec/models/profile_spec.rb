require 'rails_helper'

RSpec.describe Profile, type: :model do
  describe '#create_personal_info' do
    it 'cria as informações pessoais ao criar um perfil' do
      user = User.create(email: 'joaoalmeida@email', citizen_id_number: '38031825068',
                         password: '123456', full_name: 'João Almeida')

      expect(user.profile.personal_info).to be_present
    end
  end

  describe '#followed_count' do
    it 'retorna o número de perfis que o usuário segue no momento' do
      first_followed = create(:user)
      second_followed = create(:user, full_name: 'Gabriel Manika', email: 'emailaleatorio@email.com',
                                      citizen_id_number: '24432047070')
      third_followed = create(:user, full_name: 'Eliseu Ramos', email: 'eliseu@email.com',
                                     citizen_id_number: '60599066059')
      follower = create(:user, full_name: 'Rosemilson Barbosa', email: 'rosemilson@email.com',
                               citizen_id_number: '03971055095')

      Connection.create!(follower: follower.profile, followed_profile: first_followed.profile, status: 'inactive')
      Connection.create!(follower: follower.profile, followed_profile: second_followed.profile, status: 'active')
      Connection.create!(follower: follower.profile, followed_profile: third_followed.profile, status: 'active')

      expect(follower.profile.followed_count).to eq 2
    end
  end

  describe '#followers_count' do
    it 'retorna o número de seguidores ativos de um usuário' do
      first_follower = create(:user)
      second_follower = create(:user, full_name: 'Gabriel Manika', email: 'emailaleatorio@email.com',
                                      citizen_id_number: '24432047070')
      third_follower = create(:user, full_name: 'Eliseu Ramos', email: 'eliseu@email.com',
                                     citizen_id_number: '60599066059')
      followed = create(:user, full_name: 'Rosemilson Barbosa', email: 'rosemilson@email.com',
                               citizen_id_number: '03971055095')
      Connection.create!(follower: first_follower.profile, followed_profile: followed.profile, status: 'inactive')
      Connection.create!(follower: second_follower.profile, followed_profile: followed.profile, status: 'active')
      Connection.create!(follower: third_follower.profile, followed_profile: followed.profile, status: 'active')

      expect(followed.profile.followers_count).to eq 2
    end
  end

  describe '#following?' do
    it 'retorna false para uma conexão inativa' do
      follower = create(:user)
      followed = create(:user, full_name: 'Rosemilson Barbosa', email: 'rosemilson@email.com',
                               citizen_id_number: '03971055095')
      Connection.create!(follower: follower.profile, followed_profile: followed.profile, status: 'inactive')

      expect(followed.profile.following?(follower.profile)).to eq false
    end

    it 'retorna false para uma conexão inexistente' do
      follower = create(:user)
      followed = create(:user, full_name: 'Rosemilson Barbosa', email: 'rosemilson@email.com',
                               citizen_id_number: '03971055095')

      expect(followed.profile.following?(follower.profile)).to eq false
    end

    it 'retorna true para uma conexão ativa' do
      follower = create(:user)
      followed = create(:user, full_name: 'Rosemilson Barbosa', email: 'rosemilson@email.com',
                               citizen_id_number: '03971055095')
      Connection.create!(follower: follower.profile, followed_profile: followed.profile, status: 'active')

      expect(followed.profile.following?(follower.profile)).to eq true
    end
  end

  describe '#inactive_follower?' do
    it 'retorna true para uma conexão inativa' do
      follower = create(:user)
      followed = create(:user, full_name: 'Rosemilson Barbosa', email: 'rosemilson@email.com',
                               citizen_id_number: '03971055095')
      Connection.create!(follower: follower.profile, followed_profile: followed.profile, status: 'inactive')

      expect(followed.profile.inactive_follower?(follower.profile)).to eq true
    end

    it 'retorna false para uma conexão inexistente' do
      follower = create(:user)
      followed = create(:user, full_name: 'Rosemilson Barbosa', email: 'rosemilson@email.com',
                               citizen_id_number: '03971055095')

      expect(followed.profile.inactive_follower?(follower.profile)).to eq false
    end

    it 'retorna false para uma conexão ativa' do
      follower = create(:user)
      followed = create(:user, full_name: 'Rosemilson Barbosa', email: 'rosemilson@email.com',
                               citizen_id_number: '03971055095')
      Connection.create!(follower: follower.profile, followed_profile: followed.profile, status: 'active')

      expect(followed.profile.inactive_follower?(follower.profile)).to eq false
    end
  end

  describe '#advanced_search' do
    it 'encontra usuários procurando pelo nome' do
      create(:user, full_name: 'João')
      create(:user, full_name: 'André')
      create(:user, full_name: 'Gyodai')
      create(:user, full_name: 'Rodrigo Gyodai')
      create(:user, full_name: 'Rosemilson')
      create(:user, full_name: 'Rosemilson Barbosa')

      found_profiles = Profile.advanced_search('ro')

      expect(found_profiles.count).to eq(3)
      expect(found_profiles[0].full_name).to eq('Rodrigo Gyodai')
      expect(found_profiles[1].full_name).to eq('Rosemilson')
      expect(found_profiles[2].full_name).to eq('Rosemilson Barbosa')
    end

    it 'encontra usuários procurando por cidade' do
      joao = create(:user, full_name: 'João')
      andre = create(:user, full_name: 'André')
      joao.profile.personal_info.update!(city: 'São Paulo')
      andre.profile.personal_info.update!(city: 'Curitiba')

      found_profiles = Profile.advanced_search('são')

      expect(found_profiles.count).to eq(1)
      expect(found_profiles[0].full_name).to eq('João')
    end

    it 'encontra usuários procurando por categoria de trabalho' do
      joao = create(:user, full_name: 'João')
      andre = create(:user, full_name: 'André')
      first_category = create(:job_category, name: 'Web Design')
      second_category = create(:job_category, name: 'Modelagem 3D')
      joao.profile.profile_job_categories.create!(job_category: first_category)
      andre.profile.profile_job_categories.create!(job_category: second_category)

      found_profiles = Profile.advanced_search('web')

      expect(found_profiles.count).to eq(1)
      expect(found_profiles[0].full_name).to eq('João')
    end

    it 'encontra resultados mistos' do
      joao = create(:user, full_name: 'João')
      andre = create(:user, full_name: 'André')
      cesar = create(:user, full_name: 'César')
      gabriel = create(:user, full_name: 'Gabriel')
      first_category = create(:job_category, name: 'Jornalista')
      second_category = create(:job_category, name: 'Modelagem 3D')
      andre.profile.profile_job_categories.create!(job_category: first_category)
      joao.profile.profile_job_categories.create!(job_category: second_category)
      cesar.profile.personal_info.update!(city: 'São João')

      found_profiles = Profile.advanced_search('jo')

      expect(found_profiles.count).to eq(3)
      expect(found_profiles).to_not include gabriel.profile
    end
  end

  describe '#most_followed' do
    it 'retorna os 3 mais seguidos' do
      first_user = create(:user)
      second_user = create(:user)
      third_user = create(:user)
      fourth_user = create(:user)
      fifth_user = create(:user)

      Connection.create!(follower: second_user.profile, followed_profile: first_user.profile)
      Connection.create!(follower: third_user.profile, followed_profile: first_user.profile)
      Connection.create!(follower: fourth_user.profile, followed_profile: first_user.profile)
      Connection.create!(follower: fifth_user.profile, followed_profile: first_user.profile)

      Connection.create!(follower: third_user.profile, followed_profile: second_user.profile)
      Connection.create!(follower: fourth_user.profile, followed_profile: second_user.profile)
      Connection.create!(follower: fifth_user.profile, followed_profile: second_user.profile)

      Connection.create!(follower: fourth_user.profile, followed_profile: third_user.profile)
      Connection.create!(follower: fifth_user.profile, followed_profile: third_user.profile)

      result = Profile.most_followed(3)

      expect(result.length).to eq 3
      expect(result.first).to eq first_user.profile
      expect(result.second).to eq second_user.profile
      expect(result.third).to eq third_user.profile
    end

    it 'retorna perfil com menor id (mais antigo) se tiverem mesma quantidade de seguidor' do
      first_user = create(:user)
      second_user = create(:user)

      Connection.create!(follower: second_user.profile, followed_profile: first_user.profile)
      Connection.create!(follower: first_user.profile, followed_profile: second_user.profile)

      result = Profile.most_followed(1)

      expect(result.length).to eq 1
      expect(result.first).to eq first_user.profile
    end
  end

  describe '#inactive' do
    it 'arquiva dados do usuário' do
      user = create(:user, full_name: 'James')
      profile = create(:profile, user:)
      post1 = create(:post, user:, status: 'published')
      post2 = create(:post, user:, status: 'draft')
      post3 = create(:post, user:, status: 'archived')
      other_user = create(:user)
      Connection.create(follower: profile, followed_profile: other_user.profile)
      Connection.create(follower: other_user.profile, followed_profile: profile)

      profile.inactive!

      expect(user.reload.full_name).to eq 'Perfil Desativado'
      expect(profile.reload).to be_inactive
      expect(post1.reload).to be_archived
      expect(post2.reload).to be_archived
      expect(post3.reload).to be_archived
      expect(Connection.inactive.count).to eq 2
    end
  end

  describe '#active' do
    it 'restaura dados do usuário' do
      user = create(:user, full_name: 'James')
      profile = create(:profile, user:)
      post1 = create(:post, user:, status: 'published')
      post2 = create(:post, user:, status: 'draft')
      post3 = create(:post, user:, status: 'archived')
      other_user = create(:user)
      Connection.create(follower: profile, followed_profile: other_user.profile)
      Connection.create(follower: other_user.profile, followed_profile: profile)
      profile.inactive!

      profile.active!

      expect(user.reload.full_name).to eq 'James'
      expect(profile.reload).to be_active
      expect(post1.reload).to be_published
      expect(post2.reload).to be_draft
      expect(post3.reload).to be_archived
      expect(Connection.active.count).to eq 2
    end
  end

  describe '#order_by_premium' do
    it 'retorna perfis premium primeiro e depois os perfis free' do
      create(:user, :free, full_name: 'André Porteira')
      create(:user, :free, full_name: 'Eliseu Ramos')
      create(:user, :paid, full_name: 'Moisés Campus')
      user_premium_inactive = create(:user, full_name: 'Joao Almeida')
      user_premium_inactive.subscription.inactive!

      result = Profile.order_by_premium

      expect(result.first.full_name).to eq 'Moisés Campus'
      expect(result.second.full_name).to eq 'André Porteira'
      expect(result.third.full_name).to eq 'Eliseu Ramos'
      expect(result.fourth.full_name).to eq 'Joao Almeida'
    end

    it 'ordena por nome em caso de mesmo status de assinatura' do
      create(:user, :free, full_name: 'André Almeida')
      create(:user, :free, full_name: 'André Barbosa')
      create(:user, :paid, full_name: 'André Campus')
      create(:user, :paid, full_name: 'André Dias')

      result = Profile.order_by_premium

      expect(result.first.full_name).to eq 'André Campus'
      expect(result.second.full_name).to eq 'André Dias'
      expect(result.third.full_name).to eq 'André Almeida'
      expect(result.fourth.full_name).to eq 'André Barbosa'
    end
  end
end
