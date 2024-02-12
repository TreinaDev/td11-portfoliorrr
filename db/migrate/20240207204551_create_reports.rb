class CreateReports < ActiveRecord::Migration[7.1]
  def change
    create_table :reports do |t|
      t.text :message
      t.integer :status
      t.references :profile, null: false, foreign_key: true
      t.references :reportable, null: false, polymorphic: true
      t.string :offence_type, null: false

      t.timestamps
    end
  end
end
