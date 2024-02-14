class CreateBillings < ActiveRecord::Migration[7.1]
  def change
    create_table :billings do |t|
      t.decimal :amount, precision: 8, scale: 2, null: false
      t.references :subscription, null: false, foreign_key: true
      t.date :billing_date, null: false

      t.timestamps
    end
  end
end
