# frozen_string_literal: true

module Organized
  class TasksController < BaseController
    respond_to :html, :json

    def index
      @tasks = current_organization.tasks.order('name')
      respond_with @tasks
    end

    def create
      @task = current_organization.tasks.create task_params
      respond_with current_organization, @task
    end

    private

    def task_params
      params.require(:task).permit(:name)
    end
  end
end
