# frozen_string_literal: true

class AddNameToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    User.find_each do |user|
      name, surname = user.email.split '@'
      user.update_attributes first_name: name, last_name: surname
    end
    change_column :users, :first_name, :string, null: false
    change_column :users, :last_name, :string, null: false
  end
end
