class CreateReportEntriesExports < ActiveRecord::Migration[5.1]
  def change
    create_table :report_entries_exports, id: :uuid do |t|
      t.uuid :organization_id, null: false
      t.uuid :user_id, null: false
      t.json :export_query
      t.string :file
      t.datetime :completed_at
      t.timestamps
    end
    add_foreign_key :report_entries_exports, :users
    add_foreign_key :report_entries_exports, :organizations
  end
end
