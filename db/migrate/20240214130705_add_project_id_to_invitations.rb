class AddProjectIdToInvitations < ActiveRecord::Migration[7.1]
  def change
    add_column :invitations, :project_id, :integer, null: false
  end
end
