class Like < ApplicationRecord
  belongs_to :user
  belongs_to :likeable, polymorphic: true
  validates :likeable_id, uniqueness: { scope: %i[user_id likeable_type] }
end
