class PersonalInfo < ApplicationRecord
  belongs_to :profile
  has_one :user, through: :profile

  def non_empty_attributes
    attributes.reject { |key, value| value.blank? || filter_keys(key) }
  end

  def non_date_attributes
    attributes.reject { |key, _| filter_keys(key) }
  end

  def filter_keys(key)
    %w[created_at updated_at id profile_id].include?(key)
  end
end
