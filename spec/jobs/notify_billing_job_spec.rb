require 'rails_helper'

RSpec.describe NotifyBillingJob, type: :job do
  context 'envia email de cobrança ' do
    it 'para usuário com assinatura premium' do
      user = create(:user, :paid, full_name: 'Marcos Madeira', email: 'marcos@madeira.com')
      billing = user.subscription.billings.first

      mail = double('mail', deliver: true)
      mailer = double('BillingsMailer', notifify_billing: mail)

      allow(BillingsMailer).to receive(:with).and_return(mailer)
      allow(mailer).to receive(:notify_billing).and_return(mail)

      NotifyBillingJob.perform_now(billing)

      expect(mail).to have_received(:deliver).once
    end

    it 'A cobrança é recriada para ser enviada via email no próximo mês' do
      user = create(:user, :paid, full_name: 'Marcos Madeira', email: 'marcos@madeira.com')
      billing = user.subscription.billings.first

      expect { NotifyBillingJob.perform_now(billing) }.to have_enqueued_job(NotifyBillingJob).on_queue('default')
    end
  end
end
