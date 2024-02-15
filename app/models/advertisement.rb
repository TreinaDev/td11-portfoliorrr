class Advertisement < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  def self.displayed
    where("created_at + display_time < ?", Time.zone.now).sample(1)
  end
end
