class AddStatusToWeeklyApps < ActiveRecord::Migration[5.2]
  def change
    add_column :weekly_apps, :status, :integer
  end
end
