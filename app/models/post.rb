class Post < ApplicationRecord
  belongs_to :user
  validates :title, :content, presence: true
  has_many :comments, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  validate :correct_file_type
  validate :file_size

  acts_as_ordered_taggable_on :tags

  enum pin: { unpinned: 0, pinned: 10 }

  has_rich_text :content

  def self.get_sample(amount)
    all.sample amount
  end

  private

  def correct_file_type
    options = %w[image/jpeg image/png application/pdf audio/mpeg video/mp4]

    return unless content.body&.to_s&.include?('content-type=')

    content_types = content.body.to_s.scan(/content-type="(.*?)"/)

    content_types.each do |type|
      errors.add(:content, 'Tipo de arquivo inválido.') unless options.include? type[0]
    end
  end

  def file_size
    return unless content.body.attachments.any?

    test_file_size(content.body.attachments)
  end

  def test_file_size(attachments)
    attachments.each do |attachment|
      validate_attachment_size(attachment, 'image/png', 2_000_000, 'Tamanho de imagem permitido é 2mb')
      validate_attachment_size(attachment, 'image/jpeg', 2_000_000, 'Tamanho de imagem permitido é 2mb')
      validate_attachment_size(attachment, 'video/mp4', 15_000_000, 'Tamanho do vídeo permitido é 15mb')
      validate_attachment_size(attachment, 'audio/mpeg', 3_000_000, 'Tamanho do áudio permitido é 3mb')
      validate_attachment_size(attachment, 'application/pdf', 900_000, 'Tamanho do PDF permitido é 900kb')
    end
  end

  def validate_attachment_size(attachment, content_type, size_limit, error_message)
    return unless attachment.attachable.content_type == content_type && attachment.attachable.byte_size > size_limit

    errors.add(:content, error_message)
  end
end
