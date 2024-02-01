class ChangeDefaulValueToProfessionalInfoVisibility < ActiveRecord::Migration[7.1]
  def change
    change_column_default  :professional_infos, :visibility, true
  end
end
