class AddLangToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :lang, :string
  end
end
