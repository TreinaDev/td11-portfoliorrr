class AddOldNameToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :old_name, :string
  end
end
