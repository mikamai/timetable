# frozen_string_literal: true

class MigrateTasks < ActiveRecord::Migration[5.1]
  def up
    add_column :time_entries, :project_id, :uuid
    add_column :tasks, :organization_id, :uuid
    Task.find_each do |task|
      project = Project.find task.old_project_id
      task.update_column :organization_id, project.organization_id
      task.projects << project
      TimeEntry.where(task_id: task.id).update_all project_id: project.id
    end
    remove_column :tasks, :old_project_id
    change_column :tasks, :organization_id, :uuid, null: false
    change_column :time_entries, :project_id, :uuid, null: false
    add_foreign_key :tasks, :organizations
    add_foreign_key :time_entries, :projects
  end

  def down
    add_column :tasks, :old_project_id, :uuid
    Task.find_each do |task|
      task.update_column :old_project_id, task.projects.first.id
      task.projects.clear
    end
    remove_column :tasks, :organization_id
    remove_column :time_entries, :project_id
  end
end
