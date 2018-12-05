class AddTimeOffPeriodIdToTimeOffEntries < ActiveRecord::Migration[5.1]
  def change
    add_column :time_off_entries, :time_off_period_id, :uuid
  end
end
