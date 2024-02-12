class AddSearchNameToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :search_name, :string
  end
end
