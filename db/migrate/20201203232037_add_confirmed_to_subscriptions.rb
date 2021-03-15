class AddConfirmedToSubscriptions < ActiveRecord::Migration[5.2]
  def change
    add_column :subscriptions, :confirmed, :boolean
  end
end
