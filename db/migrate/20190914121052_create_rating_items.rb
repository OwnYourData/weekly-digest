class CreateRatingItems < ActiveRecord::Migration[5.2]
  def change
    create_table :rating_items do |t|
      t.string :title
      t.string :group
      t.string :info_url
      t.string :string

      t.timestamps
    end
  end
end
