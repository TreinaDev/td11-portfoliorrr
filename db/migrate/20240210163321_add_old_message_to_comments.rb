class AddOldMessageToComments < ActiveRecord::Migration[7.1]
  def change
    add_column :comments, :old_message, :text
  end
end
