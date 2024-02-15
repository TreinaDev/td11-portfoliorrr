require 'rails_helper'

RSpec.describe BillingsMailer, type: :mailer do
  context '#notify_billing' do
    it 'envia e-mail de acordo com data de cobrança da assinatura' do
      user = create(:user, :paid, full_name: 'Marcos Madeira', email: 'marcos@madeira.com')

      billing = user.subscription.billings.first

      mail = BillingsMailer.with(billing:).notify_billing

      expect(mail.subject).to eq 'Porfoliorrr - Assinatura mensal'
      expect(mail.to).to eq ['marcos@madeira.com']
      expect(mail.from).to eq ['billing@portfoliorrr.com']
      expect(mail.body).to include 'Olá, Marcos Madeira!'
      expect(mail.body).to include 'Sua assinatura mensal do Porfoliorrr Premium vence hoje'
      expect(mail.body).to include 'Efetue o pagamento para continuar usando os benefícios da sua assinatura'
      expect(mail.body).to include "Vencimento: #{I18n.l(billing.billing_date)}"
      expect(mail.body).to include 'Valor: R$ 19,90'
    end
  end
end
