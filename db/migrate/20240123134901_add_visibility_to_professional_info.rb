class AddVisibilityToProfessionalInfo < ActiveRecord::Migration[7.1]
  def change
    add_column :professional_infos, :visibility, :boolean
  end
end
