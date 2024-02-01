class Post < ApplicationRecord
  belongs_to :user
  validates :title, :content, presence: true
  has_many :comments, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  validate :correct_file_type

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
end
