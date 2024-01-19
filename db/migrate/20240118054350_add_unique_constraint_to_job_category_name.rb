class AddUniqueConstraintToJobCategoryName < ActiveRecord::Migration[7.1]
  def change
    add_index :job_categories, :name, unique: true
  end
end
