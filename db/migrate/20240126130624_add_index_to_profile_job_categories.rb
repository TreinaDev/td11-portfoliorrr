class AddIndexToProfileJobCategories < ActiveRecord::Migration[7.1]
  def change
    add_index :profile_job_categories, [:job_category_id, :profile_id], unique: true
  end
end
