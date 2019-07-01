class AddMediaUrlToWeeklyApps < ActiveRecord::Migration[5.2]
  def change
    add_column :weekly_apps, :media_url, :string
  end
end
