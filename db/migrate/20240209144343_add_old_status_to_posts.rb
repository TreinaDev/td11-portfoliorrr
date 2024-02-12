class AddOldStatusToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :old_status, :string
  end
end
