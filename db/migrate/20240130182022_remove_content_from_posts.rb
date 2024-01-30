class RemoveContentFromPosts < ActiveRecord::Migration[7.1]
  def change
    remove_column :posts, :content
  end
end
