class CreateProfessionalInfos < ActiveRecord::Migration[7.1]
  def change
    create_table :professional_infos do |t|
      t.string :company
      t.string :position
      t.date :start_date
      t.date :end_date
      t.references :profile, null: false, foreign_key: true

      t.timestamps
    end
  end
end
