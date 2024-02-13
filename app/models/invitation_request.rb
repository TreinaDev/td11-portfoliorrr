class InvitationRequest < ApplicationRecord
  belongs_to :profile

  validates :profile, uniqueness: { scope: :project_id }

  enum status: { processing: 0, pending: 5, accepted: 10, refused: 15, error: 20, aborted: 25 }

  after_create :queue_request_invitation_job

  def process_colabora_api_response(response)
    response = json_treated_response(response)
    if response.keys.first == 'data'
      pending!
    elsif response['errors'].first == 'Erro interno de servidor.'
      raise Exceptions::ColaBoraAPIOffline
    else
      error!
    end
  end

  def create_json_for_proposal_request
    { data: { proposal: { invitation_request_id: id,
                          project_id:,
                          profile_id: profile.id,
                          email: profile.email,
                          message: } } }.as_json
  end

  private

  def json_treated_response(response)
    return response.body if response.body.is_a?(Hash)

    JSON.parse(response.body)
  end

  def queue_request_invitation_job
    RequestInvitationJob.perform_later(invitation_request: self)
  end
end
