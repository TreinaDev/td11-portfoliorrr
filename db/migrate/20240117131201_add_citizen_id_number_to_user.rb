class AddCitizenIdNumberToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :citizen_id_number, :string
    add_index :users, :citizen_id_number
  end
end
