class AddStatusToProfiles < ActiveRecord::Migration[7.1]
  def change
    add_column :profiles, :status, :integer, default: 5
  end
end
