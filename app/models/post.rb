class Post < ApplicationRecord
  belongs_to :user
  validates :title, :content, presence: true

  enum pin: { unpinned: 0, pinned: 10 }

  def self.get_sample(amount)
    all.sample amount
  end

  def update_pin(value)
    # rubocop:disable Rails/SkipsModelValidations
    update_column(:pin, value)
    # rubocop:enable Rails/SkipsModelValidations
  end
end
