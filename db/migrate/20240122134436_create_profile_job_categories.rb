class CreateProfileJobCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :profile_job_categories do |t|
      t.references :profile, null: false, foreign_key: true
      t.references :job_category, null: false, foreign_key: true
      t.text :description

      t.timestamps
    end
  end
end
