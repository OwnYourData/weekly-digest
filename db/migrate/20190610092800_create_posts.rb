class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.integer :weekly_id
      t.integer :user_id
      t.date :post_date
      t.string :title
      t.string :url
      t.string :media_url
      t.string :media_type
      t.text :description
      t.string :category
      t.integer :status

      t.timestamps
    end
  end
end
