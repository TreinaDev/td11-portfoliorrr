class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :reports, as: :reportable, dependent: :destroy

  validates :title, :content, :status, presence: true
  validates :published_at, presence: true, if: -> { scheduled? }
  validate :correct_file_type
  validate :file_size
  validate :validate_published_at

  enum status: { published: 0, archived: 5, draft: 10, scheduled: 15, removed: 20 }
  acts_as_ordered_taggable_on :tags

  enum pin: { unpinned: 0, pinned: 10 }

  after_commit :schedule_post, on: %i[create update]
  after_create :create_notification_to_followers

  has_rich_text :content

  def self.get_sample(amount)
    published.sample amount
  end

  def exists_image_attached?
    if content.body.attachments.any?
      content.body.attachments.each do |attachment|
        return true if attachment.attachable.image?
      end
    end

    false
  end

  def first_image_attached
    content.body.attachments.each do |attachment|
      return attachment.attachable if attachment.attachable.image?
    end
  end

  private

  def create_notification_to_followers
    NewPostNotificationJob.perform_later self
  end

  def schedule_post
    return unless status == 'scheduled' && !published_at.nil?

    wait = published_at - Time.zone.now
    PostSchedulerJob.set(wait:).perform_later(self) if wait.positive?
  end

  def correct_file_type
    options = %w[image/jpeg image/png application/pdf audio/mpeg video/mp4]

    return unless content.body&.to_s&.include?('content-type=')

    content_types = content.body.to_s.scan(/content-type="(.*?)"/)

    content_types.each do |type|
      errors.add(:content, I18n.t('posts.model.invalid_file')) unless options.include? type[0]
    end
  end

  def file_size
    return unless content.body.attachments.any?

    test_file_size(content.body.attachments)
  end

  def test_file_size(attachments)
    attachments.each do |attachment|
      validate_attachment_size(attachment, 'image/png', 2_000_000, I18n.t('posts.model.max_image_size'))
      validate_attachment_size(attachment, 'image/jpeg', 2_000_000, I18n.t('posts.model.max_image_size'))
      validate_attachment_size(attachment, 'video/mp4', 15_000_000, I18n.t('posts.model.max_video_size'))
      validate_attachment_size(attachment, 'audio/mpeg', 3_000_000, I18n.t('posts.model.max_audio_size'))
      validate_attachment_size(attachment, 'application/pdf', 900_000, I18n.t('posts.model.max_pdf_size'))
    end
  end

  def validate_attachment_size(attachment, content_type, size_limit, error_message)
    return unless attachment.attachable.content_type == content_type && attachment.attachable.byte_size > size_limit

    errors.add(:content, error_message)
  end

  def validate_published_at
    return if published_at.nil?
    return unless scheduled?

    errors.add(:published_at, I18n.t('posts.model.invalid_date')) if published_at < Time.zone.now
  end
end
