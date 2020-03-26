class CreateWeeklyInternals < ActiveRecord::Migration[5.2]
  def change
    create_table :weekly_internals do |t|
      t.integer :weekly_id
      t.string :lang
      t.text :intro

      t.timestamps
    end
  end
end
