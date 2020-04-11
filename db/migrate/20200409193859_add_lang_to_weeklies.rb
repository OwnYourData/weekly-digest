class AddLangToWeeklies < ActiveRecord::Migration[5.2]
  def change
    add_column :weeklies, :lang, :string
  end
end
