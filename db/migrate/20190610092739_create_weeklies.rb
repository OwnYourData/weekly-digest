class CreateWeeklies < ActiveRecord::Migration[5.2]
  def change
    create_table :weeklies do |t|
      t.date :release
      t.string :intro
      t.string :text
      t.integer :status

      t.timestamps
    end
  end
end
