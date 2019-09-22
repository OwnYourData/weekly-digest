class AddStatusToAppRatings < ActiveRecord::Migration[5.2]
  def change
    add_column :app_ratings, :status, :integer
  end
end
