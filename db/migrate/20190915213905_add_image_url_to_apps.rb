class AddImageUrlToApps < ActiveRecord::Migration[5.2]
  def change
    add_column :apps, :image_url, :string
  end
end
