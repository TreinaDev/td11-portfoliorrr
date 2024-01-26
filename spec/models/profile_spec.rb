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
end
