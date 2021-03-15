class AddLangToSubscriptions < ActiveRecord::Migration[5.2]
  def change
    add_column :subscriptions, :lang, :string
  end
end
