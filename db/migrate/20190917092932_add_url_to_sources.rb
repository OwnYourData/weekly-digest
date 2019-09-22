class AddUrlToSources < ActiveRecord::Migration[5.2]
  def change
    add_column :sources, :url, :string
  end
end
