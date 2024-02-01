class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.visibles_list
    where(visibility: true)
  end
end
