class AddStatusToTimeOffEntries < ActiveRecord::Migration[5.1]
  def change
    add_column :time_off_entries, :status, :string
  end
end
