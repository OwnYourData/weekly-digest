class CreateAppRatings < ActiveRecord::Migration[5.2]
  def change
    create_table :app_ratings do |t|
      t.integer :app_id
      t.integer :user_id

      t.timestamps
    end
  end
end
