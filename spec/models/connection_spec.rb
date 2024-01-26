require 'rails_helper'

RSpec.describe Connection, type: :model do
  describe '#valid?' do
    it 'Usuário pode seguir vários usuários' do
      follower = create(:user)
      first_followed = create(:user, full_name: 'Gabriel Manika', email: 'emailaleatorio@email.com',
                                     citizen_id_number: '24432047070')
      second_followed = create(:user, full_name: 'Rosemilson Barbosa', email: 'rosemilson@email.com',
                                      citizen_id_number: '03971055095')
      Connection.create!(follower: follower.profile, followed_profile: first_followed.profile, status: 'active')
      connection = Connection.new(follower: follower.profile, followed_profile: second_followed.profile,
                                  status: 'active')

      expect(connection).to be_valid
    end

    it 'Usuário pode ser seguido por vários usuários' do
      first_follower = create(:user)
      second_follower = create(:user, full_name: 'Gabriel Manika', email: 'emailaleatorio@email.com',
                                      citizen_id_number: '24432047070')
      followed = create(:user, full_name: 'Rosemilson Barbosa', email: 'rosemilson@email.com',
                               citizen_id_number: '03971055095')
      Connection.create!(follower: first_follower.profile, followed_profile: second_follower.profile, status: 'active')
      connection = Connection.new(follower: second_follower.profile, followed_profile: followed.profile,
                                  status: 'active')

      expect(connection).to be_valid
    end

    it 'Usuário não pode seguir ele mesmo' do
      user = create(:user)
      connection = Connection.new(follower: user.profile, followed_profile: user.profile)

      expect(connection).not_to be_valid
      expect(connection.errors[:followed_profile]).to include('não pode ser o mesmo do usuário')
    end

    it 'Não pode ter duas relações iguais entre dois usuários' do
      follower = create(:user)
      followed = create(:user, full_name: 'Gabriel Manika', email: 'emailaleatorio@email.com',
                               citizen_id_number: '24432047070')
      Connection.create!(follower: follower.profile, followed_profile: followed.profile, status: 'active')
      connection = Connection.new(follower: follower.profile, followed_profile: followed.profile,
                                  status: 'active')

      expect(connection).not_to be_valid
      expect(connection.errors[:followed_profile]).to include('já está em uso')
    end
  end
end
