class AddIntroToTags < ActiveRecord::Migration[5.2]
  def change
    add_column :tags, :intro, :text
  end
end
