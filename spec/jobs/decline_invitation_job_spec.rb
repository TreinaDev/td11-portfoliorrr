require 'rails_helper'

RSpec.describe DeclineInvitationJob, type: :job do
  include ActiveJob::TestHelper

  it 'Usuário recusa convite com sucesso' do
    fake_response = double('faraday_response', status: 200, success?: true)
    invitation = create(:invitation)
    allow(Faraday).to receive_message_chain(:new, :patch).and_return(fake_response)

    DeclineInvitationJob.perform_now(invitation)

    expect(invitation.status).to eq 'declined'
  end

  it 'Usuário tenta recusar convite inexistente' do
    allow(Faraday).to receive_message_chain(:new, :patch).and_raise(Faraday::ResourceNotFound)
    invitation = create(:invitation, colabora_invitation_id: 'NON_EXISTENT_INVITE_ID', status: :pending)

    DeclineInvitationJob.perform_now(invitation)

    expect(invitation.reload.status).to eq 'cancelled'
  end

  it 'Usuário tenta recusar convite sem estar pendente' do
    allow(Faraday).to receive_message_chain(:new, :patch).and_raise(Faraday::ConflictError)
    invitation = create(:invitation, status: :declined)

    DeclineInvitationJob.perform_now(invitation)

    expect(invitation.reload.status).to eq 'cancelled'
  end

  it 'Usuário tenta recusar convite e não consegue se conectar ao servidor' do
    allow(Faraday).to receive_message_chain(:new, :patch).and_raise(Faraday::ConnectionFailed)
    invitation = create(:invitation)

    DeclineInvitationJob.perform_now(invitation)

    expect(invitation.reload.status).to eq 'pending'
  end

  it 'Tentativa de cancelamento do convite é realizada 5 vezes' do
    allow(Faraday).to receive_message_chain(:new, :patch).and_raise(Faraday::ConnectionFailed)
    invitation = create(:invitation, status: :processing)

    perform_enqueued_jobs do
      DeclineInvitationJob.perform_later(invitation)
    end

    assert_performed_jobs 5
    expect(Invitation.count).to eq 1
    expect(Invitation.last).to be_pending
  end
end
