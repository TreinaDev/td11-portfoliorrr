require 'rails_helper'

RSpec.describe InvitationRequestsHelper, type: :helper do
  context '#css_color_class' do
    it 'retorna classe correta para o status "Processing"' do
      expect(css_color_class(:processing)).to eq 'text-secondary'
    end

    it 'retorna classe correta para o status "Pending"' do
      expect(css_color_class(:pending)).to eq 'text-info'
    end

    it 'retorna classe correta para o status "Accepted"' do
      expect(css_color_class(:accepted)).to eq 'text-success'
    end

    it 'retorna classe correta para o status "Refused"' do
      expect(css_color_class(:refused)).to eq 'text-danger'
    end

    it 'retorna classe correta para o status "Error"' do
      expect(css_color_class(:error)).to eq 'text-warning'
    end

    it 'retorna classe correta para o status "Aborted"' do
      expect(css_color_class(:aborted)).to eq 'text-danger-emphasis'
    end

    it 'retorna string vazia quando o status não existe' do
      expect(css_color_class(:foo)).to eq ''
    end
  end

  context '#invitation_request_filter_options' do
    it 'retorna um Matriz de status e as traduções' do
      expected_matrix = [%w[Processando processing],
                         %w[Pendente pending],
                         %w[Aceita accepted],
                         %w[Recusada refused],
                         %w[Erro error],
                         %w[Cancelada aborted]]
      expect(invitation_request_filter_options).to eq expected_matrix
    end
  end
end
