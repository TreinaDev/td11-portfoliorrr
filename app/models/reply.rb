class Reply < ApplicationRecord
  belongs_to :user
  belongs_to :comment

  validates :message, presence: true
end
