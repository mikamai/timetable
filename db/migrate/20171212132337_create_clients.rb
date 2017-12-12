# frozen_string_literal: true

class CreateClients < ActiveRecord::Migration[5.1]
  def change
    create_table :clients, id: :uuid do |t|
      t.uuid :organization_id, null: false
      t.string :name, null: false
      t.string :slug, null: false
      t.timestamps
    end
    add_foreign_key :clients, :organizations
    add_index :clients, %i[organization_id name], unique: true
  end
end
