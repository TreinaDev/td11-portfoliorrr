class AddReadToNotification < ActiveRecord::Migration[7.1]
  def change
    add_column :notifications, :read, :boolean, :default => false
  end
end
