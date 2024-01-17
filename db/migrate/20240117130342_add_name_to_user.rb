class AddNameToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :full_name, :string
    remove_column :profiles, :full_name, :string
  end
end
