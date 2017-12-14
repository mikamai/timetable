class CreateRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :roles, id: :uuid do |t|
      t.uuid :organization_id, null: false
      t.string :name, null: false
      t.string :slug, null: false
      t.timestamps
    end
    add_foreign_key :roles, :organizations
    add_index :roles, %i[organization_id slug], unique: true

    create_table :roles_users, id: false do |t|
      t.uuid :role_id, null: false
      t.uuid :user_id, null: false
    end
    add_foreign_key :roles_users, :roles
    add_foreign_key :roles_users, :users
    add_index :roles_users, %i[role_id user_id], unique: true
  end
end
