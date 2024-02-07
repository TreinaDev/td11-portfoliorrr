require 'rails_helper'

RSpec.describe DeclineInvitationJob, type: :job do
  it 'Usuário recusa convite com sucesso' do
    fake_response = double('faraday_response', status: 200, success?: true)
    allow(Faraday).to receive(:patch).and_return(fake_response)
    invitation = create(:invitation)

    DeclineInvitationJob.perform_now(invitation)

    expect(invitation.status).to eq 'declined'
  end

  it 'Usuário tenta recusar convite inexistente' do
    fake_response = double('faraday_response', status: 404, success?: false)
    allow(Faraday).to receive(:patch).and_return(fake_response)
    invitation = create(:invitation)

    DeclineInvitationJob.perform_now(invitation)

    expect(invitation.status).to eq 'cancelled'
  end

  it 'Usuário tenta recusar convite e não consegue se conectar ao servidor' do
    allow(Faraday).to receive(:patch)
    invitation = create(:invitation)

    DeclineInvitationJob.perform_now(invitation)

    expect(invitation.status).to eq 'pending'
  end
end
