class Post < ApplicationRecord
  belongs_to :user
  validates :title, :content, presence: true
  has_many :comments, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  acts_as_ordered_taggable_on :tags

  enum pin: { unpinned: 0, pinned: 10 }

  def self.get_sample(amount)
    all.sample amount
  end
end
