class Post < ApplicationRecord
  belongs_to :user
  validates :title, :content, presence: true
  has_many :comments, dependent: :destroy

  # has_many :likes, dependent: :destroy
  has_many :likes, as: :likeable
end
