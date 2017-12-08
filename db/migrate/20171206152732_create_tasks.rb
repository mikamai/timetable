class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks, id: :uuid do |t|
      t.uuid :project_id, null: false
      t.string :name, null: false
      t.timestamps
    end
    add_foreign_key :tasks, :projects
    add_index :tasks, [:project_id, :name], unique: true
  end
end
