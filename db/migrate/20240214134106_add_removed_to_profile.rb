class AddRemovedToProfile < ActiveRecord::Migration[7.1]
  def change
    add_column :profiles, :removed, :boolean, default: false
  end
end
