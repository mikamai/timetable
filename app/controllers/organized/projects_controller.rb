# frozen_string_literal: true

module Organized
  class ProjectsController < BaseController
    respond_to :html, :json

    before_action :fetch_project, only: %i[show edit update add_task remove_task]

    def index
      @projects = current_organization.projects.order(:name).page(params[:page])
      respond_with current_organization, @projects
    end

    def new
      @project = current_organization.projects.build
      respond_with current_organization, @project
    end

    def create
      @project = current_organization.projects.create project_params
      respond_with current_organization, @project
    end

    def show
      @project_members = @project.members.includes(:user).order('users.email')
      respond_with current_organization, @project
    end

    def edit
      respond_with current_organization, @project
    end

    def update
      @project.update_attributes project_params
      respond_with current_organization, @project
    end

    def add_task
      @task = current_organization.tasks.friendly.find params[:task_id]
      AddTaskToProject.perform @project, @task
      respond_with current_organization, @project
    end

    def remove_task
      @task = @project.tasks.friendly.find params[:task_id]
      @project.tasks.delete @task
      respond_with current_organization, @project,
                   location: -> { [current_organization, @project] }
    end

    private

    def fetch_project
      @project = current_organization.projects.friendly.find params[:id]
    end

    def project_params
      params.require(:project).permit(:client_id, :name)
    end
  end
end
