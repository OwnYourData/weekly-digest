class AddStatusToApps < ActiveRecord::Migration[5.2]
  def change
    add_column :apps, :status, :integer
  end
end
