class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.references :profile, null: false, foreign_key: true
      t.references :notifiable, polymorphic: true
      t.timestamps
    end
  end
end
