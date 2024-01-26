class AddcolumnPinToPost < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :pin, :integer, default: 0
  end
end
