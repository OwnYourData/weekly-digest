class AddDescriptionToWeeklyApps < ActiveRecord::Migration[5.2]
  def change
    add_column :weekly_apps, :description, :text
  end
end
