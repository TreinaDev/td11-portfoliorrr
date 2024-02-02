class Invitation < ApplicationRecord
  belongs_to :profile

  validates :profile_id, :project_title, :project_description,
            :project_category, :colabora_invitation_id, presence: true

  enum status: { pending: 0, accepted: 1, declined: 2, cancelled: 3, expired: 4, removed: 5 }

  after_create :set_status

  def set_status
    self.status = 'pending'
  end
end
