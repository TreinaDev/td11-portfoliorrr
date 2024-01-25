class ProfileJobCategory < ApplicationRecord
  belongs_to :profile
  belongs_to :job_category

  validates :job_category_id, presence: true
end
