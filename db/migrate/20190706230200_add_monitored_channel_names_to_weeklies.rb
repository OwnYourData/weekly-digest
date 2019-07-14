class AddMonitoredChannelNamesToWeeklies < ActiveRecord::Migration[5.2]
  def change
    add_column :weeklies, :monitored_channel_names, :text
  end
end
