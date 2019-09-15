class CreateSourceReports < ActiveRecord::Migration[5.2]
  def change
    create_table :source_reports do |t|
      t.integer :user_id
      t.string :name
      t.text :comment

      t.timestamps
    end
  end
end
