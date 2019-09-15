class CreateAppRatingItems < ActiveRecord::Migration[5.2]
  def change
    create_table :app_rating_items do |t|
      t.integer :app_rating_id
      t.integer :rating_item_id
      t.integer :rating
      t.text :comment

      t.timestamps
    end
  end
end
