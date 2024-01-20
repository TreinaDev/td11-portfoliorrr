class AddUniqueIndexToUserCitizenIdNumber < ActiveRecord::Migration[7.1]
  def change
    remove_index :users, :citizen_id_number
    add_index :users, :citizen_id_number, unique: true
  end
end
