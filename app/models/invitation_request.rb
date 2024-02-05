class InvitationRequest < ApplicationRecord
  belongs_to :profile

  validates :profile, uniqueness: { scope: :project_id }
end
