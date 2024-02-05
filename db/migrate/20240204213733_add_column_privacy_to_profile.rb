class AddColumnPrivacyToProfile < ActiveRecord::Migration[7.1]
  def change
    add_column :profiles, :privacy, :integer, default: 10
  end
end
