# frozen_string_literal: true

module Organized
  class ProjectsController < BaseController
    before_action :fetch_project, only: %i[show edit update add_task remove_task]

    helper_method :available_clients_for_project, :available_tasks_for_project,
                  :available_users_for_project

    def index
      @projects = current_organization.projects.order(:name).page(params[:page])
      respond_with current_organization, @projects
    end

    def new
      @project = current_organization.projects.build
      respond_with current_organization, @project
    end

    def show
      @project = current_organization.projects.friendly.find params[:id]
      respond_with current_organization, @project
    end

    def create
      @project = current_organization.projects.create project_params
      respond_with current_organization, @project
    end

    def edit
      respond_with current_organization, @project
    end

    def update
      @project.update_attributes project_params
      respond_with current_organization, @project
    end

    private

    def fetch_project
      @project = current_organization.projects.friendly.find params[:id]
    end

    def project_params
      params.require(:project).permit :client_id, :name,
                                      task_ids: [],
                                      members_attributes: %i[id user_id _destroy]
    end

    def available_clients_for_project
      @available_clients_for_project ||= current_organization.clients.by_name
    end

    def available_tasks_for_project
      @available_tasks_for_project ||= current_organization.tasks.by_name
    end

    def available_users_for_project
      @available_users_for_project ||= current_organization.users.by_name
    end
  end
end
