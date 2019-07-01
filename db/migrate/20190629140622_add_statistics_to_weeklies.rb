class AddStatisticsToWeeklies < ActiveRecord::Migration[5.2]
  def change
    add_column :weeklies, :users, :integer
    add_column :weeklies, :channels, :integer
    add_column :weeklies, :postings, :integer
  end
end
