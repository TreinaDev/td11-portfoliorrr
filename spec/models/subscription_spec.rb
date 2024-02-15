require 'rails_helper'

RSpec.describe Subscription, type: :model do
  context 'assinatura de usuário premium' do
    it 'cria cobrança antes do dia 29' do
      user = create(:user, :free)

      travel_to Date.parse('2024-02-10') do
        user.subscription.active!
      end

      billing = Billing.first
      expect(Billing.count).to eq 1
      expect(billing.billing_date).to eq Date.parse '2024-03-10'
      expect(billing.amount).to eq 19.90
    end

    context 'recebe cobrança no primeiro dia do mês seguinte' do
      it 'quando assinatura for no dia 29' do
        user = create(:user, :free)

        travel_to Date.parse('2024-03-29') do
          user.subscription.active!
        end

        expect(Billing.count).to eq 1
        expect(Billing.first.billing_date).to eq Date.parse '2024-05-01'
      end

      it 'quando assinatura for no dia 30' do
        user = create(:user, :free)

        travel_to Date.parse('2024-06-30') do
          user.subscription.active!
        end

        expect(Billing.count).to eq 1
        expect(Billing.first.billing_date).to eq Date.parse '2024-08-01'
      end

      it 'quando assinatura for no dia 31' do
        user = create(:user, :free)

        travel_to Date.parse('2024-10-31') do
          user.subscription.active!
        end

        expect(Billing.count).to eq 1
        expect(Billing.first.billing_date).to eq Date.parse '2024-12-01'
      end
    end
  end
end
