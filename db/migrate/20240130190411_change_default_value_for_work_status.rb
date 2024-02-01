class ChangeDefaultValueForWorkStatus < ActiveRecord::Migration[7.1]
  def change
    change_column_default :profiles, :work_status, 10
  end
end
