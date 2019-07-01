class AddStatsToWeeklies < ActiveRecord::Migration[5.2]
  def change
    add_column :weeklies, :slack_channels, :integer
    add_column :weeklies, :new_users, :integer
  end
end
