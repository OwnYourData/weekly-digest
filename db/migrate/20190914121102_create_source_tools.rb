class CreateSourceTools < ActiveRecord::Migration[5.2]
  def change
    create_table :source_tools do |t|
      t.integer :source_id
      t.integer :app_id

      t.timestamps
    end
  end
end
