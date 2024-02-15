class CreateSubscriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :status, default: 0
      t.date :start_date

      t.timestamps
    end
  end
end
