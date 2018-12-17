class AddApprovedToTimeOffEntries < ActiveRecord::Migration[5.1]
  def change
    add_column :time_off_entries, :approved, :boolean
  end
end
