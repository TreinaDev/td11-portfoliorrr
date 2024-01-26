class ChangeLike < ActiveRecord::Migration[7.1]
  def change
    change_table :likes do |t|
      t.references :likeable, polymorphic: true
    end
  end
end
