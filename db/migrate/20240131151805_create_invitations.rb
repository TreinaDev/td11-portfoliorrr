class CreateInvitations < ActiveRecord::Migration[7.1]
  def change
    create_table :invitations do |t|
      t.references :profile, null: false, foreign_key: true
      t.string :project_title, null: false
      t.text :project_description, null: false
      t.string :project_category, null: false
      t.integer :colabora_invitation_id, null: false
      t.text :message
      t.date :expiration_date
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
