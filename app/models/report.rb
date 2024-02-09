class Report < ApplicationRecord
  belongs_to :profile
  belongs_to :reportable, polymorphic: true

  enum status: { pending: 0, granted: 5, rejected: 9 }

  def truncated_message
    message.truncate(50)
  end
end
