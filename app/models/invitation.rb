class Invitation < ApplicationRecord
  belongs_to :profile
  has_one :notification, as: :notifiable, dependent: :destroy

  validates :profile_id, :project_title, :project_description,
            :project_category, :colabora_invitation_id, presence: true

  validate :expiration_date_cannot_be_in_the_past

  enum status: { pending: 0, accepted: 1, declined: 2, cancelled: 3, expired: 4, removed: 5, processing: 6 }

  after_create :set_status
  after_create :create_notification
  after_create :validate_pending_request

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

  private

  def create_notification
    Notification.create(profile:, notifiable: self)
  end

  def validate_pending_request
    project_id = InvitationRequestService::ProjectIdRetriever.send(self)

    request = InvitationRequest.pending.find_by(profile_id:, project_id:)
    request.accepted! if request.present?
  end
end
