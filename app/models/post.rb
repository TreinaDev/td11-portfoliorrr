class Post < ApplicationRecord
  belongs_to :user
  validates :title, :content, :status, presence: true
  has_many :comments, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  enum status: { published: 0, archived: 5, draft: 10 }
  acts_as_ordered_taggable_on :tags

  enum pin: { unpinned: 0, pinned: 10 }

  def self.get_sample(amount)
    published.sample amount
  end
end
