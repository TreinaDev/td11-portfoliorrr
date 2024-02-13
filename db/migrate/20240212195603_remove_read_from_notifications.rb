class RemoveReadFromNotifications < ActiveRecord::Migration[7.1]
  def change
    remove_column :notifications, :read, :boolean
  end
end
