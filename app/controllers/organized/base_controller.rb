# frozen_string_literal: true

module Organized
  class BaseController < ApplicationController
    before_action :authenticate_user!
    before_action :set_current_organization

    helper_method :available_clients, :available_projects, :available_tasks,
                  :available_users, :available_roles, :pundit_user

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

    def available_projects
      @available_projects ||= current_user.projects_in_organization.by_name
    end

    def available_tasks
      @available_tasks ||= current_organization.tasks.by_name
    end

    def available_users
      @available_users ||= current_organization.users.confirmed.by_name
    end

    def available_roles
      @available_roles ||= current_organization.roles.by_name
    end
  end
end
