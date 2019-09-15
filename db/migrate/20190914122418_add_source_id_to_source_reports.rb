class AddSourceIdToSourceReports < ActiveRecord::Migration[5.2]
  def change
    add_column :source_reports, :source_id, :integer
  end
end
