require 'rails_helper'

RSpec.describe BillingJob, type: :job do
  context 'usuário premium' do
    it 'recebe cobrança de pagamento mensal' do
      user = User.create!(full_name: 'nome completo', password: 'testes',
                          email: 'mail@email.com', citizen_id_number: '13266529073')
      user.subscription.active!
      user.subscription.update(start_date: '2024-02-10')

      perform_enqueued_jobs

      expect(Billing.count).to eq 1
    end
  end
end
