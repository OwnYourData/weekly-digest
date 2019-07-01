class CreateAppTags < ActiveRecord::Migration[5.2]
  def change
    create_table :app_tags do |t|
      t.integer :app_id
      t.integer :tag_id

      t.timestamps
    end
  end
end
