# frozen_string_literal: true

module Organized
  class TasksController < BaseController
    respond_to :json

    def create
      @project = current_organization.projects.friendly.find params[:project_id]
      @task = @project.tasks.create task_params
      respond_with current_organization, @project, @task,
                   location: -> { organization_project_path current_organization, @project }
    end

    private

    def task_params
      params.require(:task).permit(:name)
    end
  end
end
