# frozen_string_literal: true

module Organized
  class BaseController < ApplicationController
    before_action :authenticate_user!
    before_action :set_current_organization, :all_users

    helper_method :available_clients, :available_projects_for, :available_tasks,
                  :available_users, :available_roles, :pundit_user,
                  :organization_projects

    private

    def current_organization
      @organization
    end

    def pundit_user
      @pundit_user ||= current_user.membership_in current_organization
    end

    def organization_param
      params[:organization_id]
    end

    def set_current_organization
      @organization = current_user.organizations.friendly.find organization_param
      session[:last_used_organization_id] = @organization.id
    end

    def available_organizations
      @organizations ||= current_user.organizations.order(:name)
    end

    def available_clients
      @available_clients ||= current_organization.clients.by_name
    end

    def organization_projects
      @organization_projects ||= current_organization.projects.by_name
    end

    def available_projects_for user
      user.projects_in_organization(current_organization).by_name
    end

    def available_tasks
      @available_tasks ||= current_organization.tasks.by_name
    end

    def available_users
      @available_users ||= current_organization.users.confirmed.by_name
    end

    #map + reduce
    def all_users
      theusers = []
      available_organizations.each do |orga|
        #puts "#############################################"
        #puts organization.name
        #puts organization.inspect
              #<Organization id: "7879c6cc-4a40-49f8-bd31-26ab836df5d2", name: "Mikamai", slug: "mikamai", created_at: "2019-09-04 15:01:32", updated_at: "2019-09-04 15:01:32">
        #current_user.organizations.friendly.find organization_param
              #all_users.push(organization.users)
        #organization.users.each do |user|
        #  puts "++++++++++++++++++++++"
        #  puts user.inspect
        #  users.push(user)
        #end
        theusers += orga.users
      end
      #puts all_users.inspect
      #all_users.push("coucou")
       theusers
    end

    def available_roles
      @available_roles ||= current_organization.roles.by_name
    end
  end
end
