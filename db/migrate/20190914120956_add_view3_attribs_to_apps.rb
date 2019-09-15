class AddView3AttribsToApps < ActiveRecord::Migration[5.2]
  def change
    add_column :apps, :available_since, :date
    add_column :apps, :mydata_membership, :string
    add_column :apps, :license, :string
    add_column :apps, :user_id, :integer
  end
end
