class AddInviteToWeeklies < ActiveRecord::Migration[5.2]
  def change
    add_column :weeklies, :invite, :text
    add_column :weeklies, :invite_date, :datetime
  end
end
