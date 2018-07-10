class AddArchivedAtToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :archived_at, :datetime
    add_index :projects, :archived_at
  end
end
