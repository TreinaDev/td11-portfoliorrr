class JobCategory < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  has_many :profile_job_categories, dependent: :restrict_with_error
end
