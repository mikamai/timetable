# frozen_string_literal: true

module Organized
  class TasksController < BaseController
    def index
      @tasks = current_organization.tasks.by_name.page params[:page]
      authorize Task
      respond_with current_organization, @tasks
    end

    def new
      @task = current_organization.tasks.build
      authorize @task
      respond_with current_organization, @task
    end

    def create
      @task = current_organization.tasks.build task_params
      authorize @task
      @task.save
      respond_with current_organization, @task
    end

    def edit
      @task = current_organization.tasks.friendly.find params[:id]
      authorize @task
      respond_with current_organization, @task
    end

    def update
      @task = current_organization.tasks.friendly.find params[:id]
      authorize @task
      @task.update_attributes task_params
      respond_with current_organization, @task
    end

    private

    def task_params
      params.require(:task).permit(:name)
    end
  end
end
