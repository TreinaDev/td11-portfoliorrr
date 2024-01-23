class Post < ApplicationRecord
  belongs_to :user
  validates :title, :content, presence: true
  has_many :comments, dependent: :destroy
end
