class Invitation < ApplicationRecord
  belongs_to :profile
  has_one :notification, as: :notifiable, dependent: :destroy

  validates :profile_id, :project_id, :project_title, :project_description,
            :project_category, :colabora_invitation_id, presence: true

  validate :expiration_date_cannot_be_in_the_past

  enum status: { pending: 0, accepted: 1, declined: 2, cancelled: 3, expired: 4, removed: 5, processing: 6 }

  after_create :set_status
  after_create :create_notification
  after_create :validate_and_approve_pending_request

  extend FriendlyId
  friendly_id :project_title, use: :slugged

  def set_status
    self.status = 'pending'
  end

  def expiration_date_cannot_be_in_the_past
    return unless expiration_date.present? && expiration_date < Time.zone.today

    errors.add(:expiration_date, I18n.t('invitations.date_error'))
  end

  def truncate_description
    project_description.truncate(30)
  end

  private

  def create_notification
    Notification.create(profile:, notifiable: self)
  end

  def validate_and_approve_pending_request
    pending_invitation_request = InvitationRequest.pending.find_by(profile_id:, project_id:)
    pending_invitation_request&.accepted!
  end
end
