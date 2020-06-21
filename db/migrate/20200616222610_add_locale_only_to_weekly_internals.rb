class AddLocaleOnlyToWeeklyInternals < ActiveRecord::Migration[5.2]
  def change
    add_column :weekly_internals, :locale_only, :boolean, :default => false
  end
end
