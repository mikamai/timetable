class AddApprovedToTimeOffPeriods < ActiveRecord::Migration[5.1]
  def change
    add_column :time_off_periods, :approved, :boolean
  end
end
