class Post < ApplicationRecord
  belongs_to :user
  validates :title, :content, presence: true

  def self.get_sample(amount)
    all.sample amount
  end
end
