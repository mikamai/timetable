# frozen_string_literal: true

module Organized
  class ProjectsController < BaseController
    def index
      @projects = current_user.projects.in_organization(current_organization)
                              .order(:name).page(params[:page])
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
      @project = current_organization.projects.friendly.find params[:id]
      @project_members = @project.project_memberships.includes(:user).order('users.email')
      respond_with current_organization, @project
    end

    def edit
      @project = current_organization.projects.friendly.find params[:id]
      respond_with current_organization, @project
    end

    def update
      @project = current_organization.projects.friendly.find params[:id]
      @project.update_attributes project_params
      respond_with current_organization, @project
    end

    private

    def project_params
      params.require(:project).permit(:organization_id, :name)
    end
  end
end
