class CreateTimeOffEntries < ActiveRecord::Migration[5.1]
  def change
    create_table :time_off_entries, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.date :executed_on, null: false
      t.integer :amount, null: false
      t.string :typology
      t.string :notes
      t.timestamps
    end
  end
end
