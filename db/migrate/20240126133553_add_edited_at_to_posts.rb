class AddEditedAtToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :edited_at, :datetime, default: Time.zone.now
  end
end
