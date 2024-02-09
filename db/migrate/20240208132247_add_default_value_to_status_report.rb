class AddDefaultValueToStatusReport < ActiveRecord::Migration[7.1]
  def change
    change_column :reports, :status, :integer, default: 0
  end
end
