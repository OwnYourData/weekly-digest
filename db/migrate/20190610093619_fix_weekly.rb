class FixWeekly < ActiveRecord::Migration[5.2]
  def change
  	remove_column :weeklies, :text
  	change_column :weeklies, :intro, :text
  end
end
