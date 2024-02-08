class InvitationRequest < ApplicationRecord
  belongs_to :profile

  validates :profile, uniqueness: { scope: :project_id }

  after_create :queue_request_invitation_job

  private

  def queue_request_invitation_job
    RequestInvitationJob.perform_later(invitation_request: self)
  end
end
