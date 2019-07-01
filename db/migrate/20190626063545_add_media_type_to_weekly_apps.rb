class AddMediaTypeToWeeklyApps < ActiveRecord::Migration[5.2]
  def change
    add_column :weekly_apps, :media_type, :string
  end
end
