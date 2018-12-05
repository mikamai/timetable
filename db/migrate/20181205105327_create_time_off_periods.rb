class CreateTimeOffPeriods < ActiveRecord::Migration[5.1]
  def change
    create_table :time_off_periods, id: :uuid do |t|
      t.string :typology
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.uuid :user_id, null: false
      t.uuid :organization_id, null: false

      t.timestamps
    end
  end
end
