class AddWorkStatusToProfiles < ActiveRecord::Migration[7.1]
  def change
    add_column :profiles, :work_status, :integer, default: 1
  end
end
