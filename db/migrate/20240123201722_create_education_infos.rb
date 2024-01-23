class CreateEducationInfos < ActiveRecord::Migration[7.1]
  def change
    create_table :education_infos do |t|
      t.string :institution
      t.string :course
      t.date :start_date
      t.date :end_date
      t.boolean :visibility, default: true
      t.references :profile, null: false, foreign_key: true

      t.timestamps
    end
  end
end
