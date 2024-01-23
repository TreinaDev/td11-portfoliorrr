require 'rails_helper'

RSpec.describe Follower, type: :model do
  describe '#valid?' do
    it 'Usuário pode seguir vários usuários' do
      follower = create(:user)
      first_followed = create(:user, full_name: 'Gabriel Manika', email: 'emailaleatorio@email.com',
                                     citizen_id_number: '24432047070')
      second_followed = create(:user, full_name: 'Rosemilson Barbosa', email: 'rosemilson@email.com',
                                      citizen_id_number: '03971055095')
      Follower.create!(follower: follower.profile, followed_profile: first_followed.profile, status: 'active')
      follow_relationship = Follower.new(follower: follower.profile, followed_profile: second_followed.profile,
                                         status: 'active')

      expect(follow_relationship).to be_valid
    end

    it 'Usuário pode ser seguido por vários usuários' do
      first_follower = create(:user)
      second_follower = create(:user, full_name: 'Gabriel Manika', email: 'emailaleatorio@email.com',
                                      citizen_id_number: '24432047070')
      followed = create(:user, full_name: 'Rosemilson Barbosa', email: 'rosemilson@email.com',
                               citizen_id_number: '03971055095')
      Follower.create!(follower: first_follower.profile, followed_profile: second_follower.profile, status: 'active')
      follow_relationship = Follower.new(follower: second_follower.profile, followed_profile: followed.profile,
                                         status: 'active')

      expect(follow_relationship).to be_valid
    end

    it 'Usuário não pode seguir ele mesmo' do
      user = create(:user)
      follow_relationship = Follower.new(follower: user.profile, followed_profile: user.profile)

      expect(follow_relationship).not_to be_valid
      expect(follow_relationship.errors[:followed_profile]).to include('não pode ser o mesmo do usuário')
    end

    it 'Não pode ter duas relações iguais entre dois usuários' do
      follower = create(:user)
      followed = create(:user, full_name: 'Gabriel Manika', email: 'emailaleatorio@email.com',
                               citizen_id_number: '24432047070')
      Follower.create!(follower: follower.profile, followed_profile: followed.profile, status: 'active')
      follow_relationship = Follower.new(follower: follower.profile, followed_profile: followed.profile,
                                         status: 'active')

      expect(follow_relationship).not_to be_valid
      expect(follow_relationship.errors[:followed_profile]).to include('já está em uso')
    end
  end
end
