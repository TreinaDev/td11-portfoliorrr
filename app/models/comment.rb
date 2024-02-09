class Comment < ApplicationRecord
  validates :message, presence: true
  belongs_to :post
  belongs_to :user
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :reports, as: :reportable, dependent: :destroy
end
