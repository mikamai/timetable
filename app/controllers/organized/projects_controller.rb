# frozen_string_literal: true

module Organized
  class ProjectsController < BaseController
    before_action :fetch_project, only: %i[show edit update]
    before_action :disable_caching, only: :show

    def index
      @q = search_projects
      @projects = @q.result.includes(:client).page(params[:page])
      authorize Project
      respond_with current_organization, @projects
    end

    def new
      @project = current_organization.projects.build
      authorize @project
      respond_with current_organization, @project
    end

    def show
      authorize @project
      respond_with current_organization, @project
    end

    def create
      @project = current_organization.projects.build project_params
      authorize @project
      @project.save
      respond_with current_organization, @project
    end

    def edit
      authorize @project
      respond_with current_organization, @project
    end

    def update
      authorize @project
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

    def search_projects
      current_organization.projects.ransack(params[:q]).tap do |q|
        q.sorts = 'name asc' if q.sorts.empty?
      end
    end
  end
end
