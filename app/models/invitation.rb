class Invitation < ApplicationRecord
  belongs_to :profile

  validates :profile_id, :project_title, :project_description,
            :project_category, :colabora_invitation_id, presence: true

  validate :expiration_date_cannot_be_in_the_past

  enum status: { pending: 0, accepted: 1, declined: 2, cancelled: 3, expired: 4, removed: 5, processing: 6 }

  after_create :set_status

  def set_status
    self.status = 'pending'
  end

  def expiration_date_cannot_be_in_the_past
    return unless expiration_date.present? && expiration_date < Time.zone.today

    errors.add(:expiration_date, 'deve ser maior que a data atual')
  end

  def truncate_description
    project_description.truncate(30)
  end
end
