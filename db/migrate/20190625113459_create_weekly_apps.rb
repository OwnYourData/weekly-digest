class CreateWeeklyApps < ActiveRecord::Migration[5.2]
  def change
    create_table :weekly_apps do |t|
      t.integer :weekly_id
      t.integer :app_id
      t.integer :user_id

      t.timestamps
    end
  end
end
