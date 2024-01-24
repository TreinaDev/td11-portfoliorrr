class CreateConnections < ActiveRecord::Migration[7.1]
  def change
    create_table :followers do |t|
      t.references :follower, null: false, index: true, foreign_key: { to_table: :profiles }
      t.references :followed_profile, null: false, index: true, foreign_key: { to_table: :profiles }
      t.integer :status, default: 1

      t.timestamps
    end

    add_index :followers, [:followed_profile_id, :follower_id], unique: true
  end
end
