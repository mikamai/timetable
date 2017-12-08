# frozen_string_literal: true

class CreateTimeEntries < ActiveRecord::Migration[5.1]
  def change
    create_table :time_entries, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.uuid :task_id, null: false
      t.date :executed_on, null: false
      t.integer :minutes, null: false
      t.string :notes
      t.timestamps
    end
    add_foreign_key :time_entries, :users
    add_foreign_key :time_entries, :tasks
  end
end
