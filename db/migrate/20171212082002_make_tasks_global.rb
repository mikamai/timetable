# frozen_string_literal: true

class MakeTasksGlobal < ActiveRecord::Migration[5.1]
  def change
    create_table :projects_tasks, id: false do |t|
      t.uuid :project_id, null: false
      t.uuid :task_id, null: false
    end
    add_foreign_key :projects_tasks, :projects
    add_foreign_key :projects_tasks, :tasks
    add_index :projects_tasks, %i[project_id task_id], unique: true

    # for future migrations
    rename_column :tasks, :project_id, :old_project_id
  end
end
