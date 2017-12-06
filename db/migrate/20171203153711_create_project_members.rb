# frozen_string_literal: true

class CreateProjectMembers < ActiveRecord::Migration[5.1]
  def change
    create_table :project_members, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.uuid :project_id, null: false
      t.timestamps
    end
    add_foreign_key :project_members, :users
    add_foreign_key :project_members, :projects
    add_index :project_members, %i[user_id project_id], unique: true
  end
end
