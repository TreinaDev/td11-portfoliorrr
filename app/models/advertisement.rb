class Advertisement < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  validates :title, :link, presence: true
  validates :link, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])

  def self.displayed
    where.not(id: Advertisement.select(&:expired?)).sample(1)
  end

  def expired?
    (created_at + display_time.days) < Time.zone.now
  end
end
