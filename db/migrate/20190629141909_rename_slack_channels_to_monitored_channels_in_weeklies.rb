class RenameSlackChannelsToMonitoredChannelsInWeeklies < ActiveRecord::Migration[5.2]
  def change
    rename_column :weeklies, :slack_channels, :monitored_channels
  end
end
