class CreateTimeOffEntries < ActiveRecord::Migration[5.1]
  def change
    create_table :time_off_entries, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.uuid :organization_id, null: false
      t.uuid :time_off_period_id
      t.date :executed_on, null: false
      t.integer :amount, null: false
      t.string :typology, null: false
      t.string :status, default: 'pending'
      t.string :notes
      t.timestamps
    end
  end
end
