class Report < ApplicationRecord
  belongs_to :profile
  belongs_to :reportable, polymorphic: true

  enum status: { pending: 0, granted: 5, not_granted: 9 }
end
