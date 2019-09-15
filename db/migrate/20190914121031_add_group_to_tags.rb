class AddGroupToTags < ActiveRecord::Migration[5.2]
  def change
    add_column :tags, :group, :string
  end
end
