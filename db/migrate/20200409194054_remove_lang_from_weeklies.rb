class RemoveLangFromWeeklies < ActiveRecord::Migration[5.2]
  def change
    remove_column :weeklies, :lang
  end
end
