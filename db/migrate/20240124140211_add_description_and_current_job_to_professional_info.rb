class AddDescriptionAndCurrentJobToProfessionalInfo < ActiveRecord::Migration[7.1]
  def change
    add_column :professional_infos, :description, :text
    add_column :professional_infos, :current_job, :boolean
  end
end
