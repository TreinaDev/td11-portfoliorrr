class ProfileJobCategory < ApplicationRecord
  belongs_to :profile
  belongs_to :job_category

  validates :job_category_id, presence: true
  validates :job_category_id, uniqueness: { scope: :profile_id }

  def self.generate_profile_job_categories_json(profile_id)
    profile_job_categories = where(profile_id:)
    profile_job_categories.map do |pjc|
      { title: pjc.job_category.name, description: pjc.description }
    end
  end
end
