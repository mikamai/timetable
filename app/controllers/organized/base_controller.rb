# frozen_string_literal: true

module Organized
  class BaseController < ApplicationController
    layout 'organized'
    respond_to :html, :json

    before_action :authenticate_user!
    before_action :set_current_organization

    helper_method :current_organization, :available_organizations,
                  :available_clients, :available_projects, :available_tasks,
                  :available_users, :available_roles

    def current_organization
      @organization
    end

    private

    def organization_param
      params[:organization_id]
    end

    def set_current_organization
      @organization = current_user.organizations.friendly.find organization_param
      session[:last_organization_id] = @organization.id
    end

    def available_organizations
      @organizations ||= current_user.organizations.order(:name)
    end

    def available_clients
      @available_clients ||= current_organization.clients.by_name
    end

    def available_projects
      @available_projects ||= current_organization.projects.by_name
    end

    def available_tasks
      @available_tasks ||= current_organization.tasks.by_name
    end

    def available_users
      @available_users ||= current_organization.users.by_name
    end
  end
end
