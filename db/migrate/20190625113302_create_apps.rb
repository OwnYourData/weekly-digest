class CreateApps < ActiveRecord::Migration[5.2]
  def change
    create_table :apps do |t|
      t.string :title
      t.text :description
      t.string :url

      t.timestamps
    end
  end
end
