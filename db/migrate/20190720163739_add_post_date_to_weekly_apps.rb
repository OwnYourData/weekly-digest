class AddPostDateToWeeklyApps < ActiveRecord::Migration[5.2]
  def change
    add_column :weekly_apps, :post_date, :date
  end
end
