class ProfessionalInfo < ApplicationRecord
  after_initialize :set_default_visibility, if: :new_record?

  belongs_to :profile
  has_one :user, through: :profile

  validates :company, :position, :start_date, presence: true

  validates :end_date, presence: true, unless: :current_job?

  private

  def set_default_visibility
    self.visibility ||= true
  end
end
