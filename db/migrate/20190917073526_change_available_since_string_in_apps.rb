class ChangeAvailableSinceStringInApps < ActiveRecord::Migration[5.2]
  def change
    change_column :apps, :available_since, :string
  end
end
