class InvitationRequest < ApplicationRecord
  belongs_to :profile

  validates :profile, uniqueness: { scope: :project_id }

  after_create :queue_request_invitation_job

  enum status: { processing: 0, pending: 5, accepted: 10, refused: 15, error: 20, aborted: 25 }

  def process_colabora_api_response(response)
    response = json_treated_response(response)
    if response.keys.first == 'data'
      pending!
    elsif response['errors'].first == 'Erro interno de servidor.'
      RequestInvitationJob.set(wait: 1.hour).perform_later(invitation_request: self)
    end
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
