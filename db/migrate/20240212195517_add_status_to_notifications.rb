class AddStatusToNotifications < ActiveRecord::Migration[7.1]
  def change
    add_column :notifications, :status, :integer, default: 0
  end
end
