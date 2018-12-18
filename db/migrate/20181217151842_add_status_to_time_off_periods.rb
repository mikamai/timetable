class AddStatusToTimeOffPeriods < ActiveRecord::Migration[5.1]
  def change
    add_column :time_off_periods, :status, :string, default: 'pending'
  end
end
