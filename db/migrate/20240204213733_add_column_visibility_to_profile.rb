class AddColumnVisibilityToProfile < ActiveRecord::Migration[7.1]
  def change
    add_column :profiles, :visibility, :integer, default: 10
  end
end
