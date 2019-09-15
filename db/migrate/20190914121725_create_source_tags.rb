class CreateSourceTags < ActiveRecord::Migration[5.2]
  def change
    create_table :source_tags do |t|
      t.integer :source_id
      t.integer :tag_id

      t.timestamps
    end
  end
end
