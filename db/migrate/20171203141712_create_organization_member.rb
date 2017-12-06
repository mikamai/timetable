# frozen_string_literal: true

class CreateOrganizationMember < ActiveRecord::Migration[5.1]
  def change
    create_table :organization_members do |t|
      t.uuid :user_id, null: false
      t.uuid :organization_id, null: false
      t.boolean :admin, null: false, default: false
    end
    add_foreign_key :organization_members, :users
    add_foreign_key :organization_members, :organizations
    add_index :organization_members, %i[organization_id user_id], unique: true
  end
end
