class AddThanksToWeeklys < ActiveRecord::Migration[5.2]
  def change
    add_column :weeklies, :thanks, :integer
    add_column :weeklies, :thanked, :integer
  end
end
