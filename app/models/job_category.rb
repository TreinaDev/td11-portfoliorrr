class JobCategory < ApplicationRecord
  validates :name, presence: true
end
