class AddLangToStatistics < ActiveRecord::Migration[5.2]
  def change
    add_column :statistics, :lang, :string
  end
end
