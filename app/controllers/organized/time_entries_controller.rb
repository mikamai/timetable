# frozen_string_literal: true

module Organized
  class TimeEntriesController < BaseController
    before_action :set_time_view, only: %i[new create]

    helper_method :available_projects_for_entry,
                  :available_tasks_for_entry_project

    def new
      @time_entry = current_user.time_entries.build executed_on: @time_view.date
      respond_with current_organization, @time_entry
    end

    def create
      @time_entry = current_user.time_entries.create create_params
      respond_with current_organization, @time_entry,
                   location: -> { [current_organization, @time_entry.time_view] }
    end

    def edit
      @time_entry = current_user.time_entries.in_organization(current_organization).find params[:id]
      respond_with current_organization, @time_entry
    end

    def update
      @time_entry = current_user.time_entries.in_organization(current_organization).find params[:id]
      @time_entry.update_attributes update_params
      respond_with current_organization, @time_entry,
                   location: -> { [current_organization, @time_entry.time_view] }
    end

    private

    def create_params
      params.require(:time_entry).permit(:project_id, :task_id, :notes, :minutes_in_distance)
            .merge(executed_on: @time_view.date)
    end

    def update_params
      params.require(:time_entry).permit(:executed_on, :task_id, :notes, :minutes_in_distance)
    end

    def set_time_view
      @time_view = TimeView.find params[:time_view_id], current_organization, current_user
    end

    def available_projects_for_entry
      @available_projects ||= current_organization.projects.by_name
    end

    def available_tasks_for_entry_project
      project = @time_entry.project || available_projects_for_entry.first
      @available_tasks_for_project ||= project.tasks.by_name
    end
  end
end
