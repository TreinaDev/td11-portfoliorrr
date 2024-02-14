class AddEditedAtToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :edited_at, :datetime
  end
end
