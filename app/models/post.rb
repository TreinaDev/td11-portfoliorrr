class Post < ApplicationRecord
  belongs_to :user
  validates :title, :content, presence: true
  has_many :comments, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  enum pin: { unpinned: 0, pinned: 10 }

  has_rich_text :content

  def self.get_sample(amount)
    all.sample amount
  end
end
