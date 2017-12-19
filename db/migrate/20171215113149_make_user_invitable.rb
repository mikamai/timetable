# frozen_string_literal: true

class MakeUserInvitable < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :first_name, :string, null: true
    change_column :users, :last_name, :string, null: true
  end
end
