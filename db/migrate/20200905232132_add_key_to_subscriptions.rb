class AddKeyToSubscriptions < ActiveRecord::Migration[5.2]
  def change
    add_column :subscriptions, :key, :string
  end
end
