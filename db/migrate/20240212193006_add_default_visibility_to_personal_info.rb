class AddDefaultVisibilityToPersonalInfo < ActiveRecord::Migration[7.1]
  def change
    change_column :professional_infos, :visibility, :boolean, default: false
  end
end
