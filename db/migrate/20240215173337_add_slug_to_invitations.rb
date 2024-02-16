class AddSlugToInvitations < ActiveRecord::Migration[7.1]
  def change
    add_column :invitations, :slug, :string
    add_index :invitations, :slug, unique: true
  end
end
