class InvitationRequest < ApplicationRecord
  belongs_to :profile

  validates :profile, uniqueness: { scope: :project_id }

  enum status: { processing: 0, pending: 5, accepted: 10, refused: 15, error: 20, aborted: 25 }
end
