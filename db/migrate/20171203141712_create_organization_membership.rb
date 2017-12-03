# frozen_string_literal: true

class CreateOrganizationMembership < ActiveRecord::Migration[5.1]
  def change
    create_table :organization_memberships do |t|
      t.uuid :user_id, null: false
      t.uuid :organization_id, null: false
      t.boolean :admin, null: false, default: false
    end
    add_foreign_key :organization_memberships, :users
    add_foreign_key :organization_memberships, :organizations
    add_index :organization_memberships, %i[organization_id user_id], unique: true
  end
end
