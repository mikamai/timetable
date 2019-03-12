class AddKeycloakToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :openid_uid, :uuid, null: true
    add_index :users, :openid_uid, unique: true
  end
end
