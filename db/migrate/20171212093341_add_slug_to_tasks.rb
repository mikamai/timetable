# frozen_string_literal: true

class AddSlugToTasks < ActiveRecord::Migration[5.1]
  def change
    add_column :tasks, :slug, :string
    Task.find_each(&:save!)
    change_column :tasks, :slug, :string, null: false
  end
end
