class ProfessionalInfo < ApplicationRecord
  belongs_to :profile
  has_one :user, through: :profile

  validates :company, :position, :start_date, presence: true

  validates :end_date, presence: true, unless: :current_job?
end
