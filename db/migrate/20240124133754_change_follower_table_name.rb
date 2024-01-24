class ChangeConnectionTableName < ActiveRecord::Migration[7.1]
  def change
    rename_table :followers, :connections
  end
end
