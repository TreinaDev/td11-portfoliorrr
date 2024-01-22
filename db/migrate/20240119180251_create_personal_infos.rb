class CreatePersonalInfos < ActiveRecord::Migration[7.1]
  def change
    create_table :personal_infos do |t|
      t.references :profile, null: false, foreign_key: true
      t.string :street
      t.string :city
      t.string :state
      t.string :phone
      t.string :area
      t.boolean :visibility
      t.date :birth_date
      t.string :zip_code
      t.string :street_number

      t.timestamps
    end
  end
end
