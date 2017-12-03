# frozen_string_literal: true

class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects, id: :uuid do |t|
      t.uuid :organization_id, null: false
      t.string :name, null: false
      t.string :slug, null: false
      t.timestamps
    end
    add_foreign_key :projects, :organizations
    add_index :projects, %i[organization_id slug], unique: true
  end
end
