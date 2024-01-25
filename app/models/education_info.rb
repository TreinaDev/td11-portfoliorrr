class EducationInfo < ApplicationRecord
  belongs_to :profile
  has_one :user, through: :profile

  validates :institution, :course, :start_date, :end_date, presence: true
end
