class Report < ApplicationRecord
  belongs_to :profile
  belongs_to :reportable, polymorphic: true
end
