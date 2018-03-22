# frozen_string_literal: true

class AddBudgetToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :budget, :integer
  end
end
