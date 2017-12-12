# frozen_string_literal: true

class CreateClientsInProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :client_id, :uuid
    Organization.find_each do |organization|
      client = organization.clients.create! name: 'No Name'
      organization.projects.update_all client_id: client.id
    end
    change_column :projects, :client_id, :uuid, null: false
    add_foreign_key :projects, :clients
  end
end
