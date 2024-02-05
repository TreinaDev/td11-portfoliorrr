class CreateInvitationRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :invitation_requests do |t|
      t.references :profile, null: false, foreign_key: true
      t.text :message
      t.integer :project_id, index: true
      t.string :email

      t.timestamps
    end

    add_index :invitation_requests, [:profile_id, :project_id], unique: true
  end
end
