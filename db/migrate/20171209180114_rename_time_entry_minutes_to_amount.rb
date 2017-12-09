class RenameTimeEntryMinutesToAmount < ActiveRecord::Migration[5.1]
  def up
    rename_column :time_entries, :minutes, :amount
  end
end
