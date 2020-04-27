class AddAuthorIdToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :author_id, :integer
  end
end
