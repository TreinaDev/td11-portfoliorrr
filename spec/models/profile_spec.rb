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
end
