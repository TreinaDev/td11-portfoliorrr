require 'rails_helper'

RSpec.describe Subscription, type: :model do
  describe '#active!' do
    it 'atualiza data de início automaticamente' do
      user = create(:user, :free)
      subscription = user.subscription

      subscription.active!

      expect(subscription.start_date).to eq Time.zone.now.to_date
      expect(subscription).to be_active
    end
  end

  describe '#active!' do
    it 'atualiza data de início automaticamente' do
      user = create(:user, :free)
      subscription = user.subscription

      subscription.inactive!

      expect(subscription.start_date).to be_nil
      expect(subscription).to be_inactive
    end
  end
end
