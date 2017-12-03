# frozen_string_literal: true

class CreateProjectMemberships < ActiveRecord::Migration[5.1]
  def change
    create_table :project_memberships, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.uuid :project_id, null: false
      t.timestamps
    end
    add_foreign_key :project_memberships, :users
    add_foreign_key :project_memberships, :projects
    add_index :project_memberships, %i[user_id project_id], unique: true
  end
end
