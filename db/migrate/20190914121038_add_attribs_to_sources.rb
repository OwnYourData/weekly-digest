class AddAttribsToSources < ActiveRecord::Migration[5.2]
  def change
    add_column :sources, :description, :text
    add_column :sources, :status, :integer
    add_column :sources, :user_id, :integer
    add_column :sources, :request, :text
    add_column :sources, :response, :text
  end
end
