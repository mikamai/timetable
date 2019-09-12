class UpdateRolesForOrganizationMembers < ActiveRecord::Migration[5.1]
  def up
    add_column :organization_members, :role, :integer, null: false, default: 0
    OrganizationMember.find_each do |membership|
      role = membership.admin ? 2 : 0
      membership.update_attributes role: role
    end
    remove_column :organization_members, :admin
  end

  def down
    add_column :organization_members, :admin, :boolean, null: false, default: false
    OrganizationMember.find_each do |membership|
      admin = membership.role == 2
      membership.update_attributes admin: admin
    end
    remove_column :organization_members, :role
  end
end