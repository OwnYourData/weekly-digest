class CreateAppCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :app_categories do |t|
      t.integer :category_id
      t.integer :app_id

      t.timestamps
    end
  end
end
