# frozen_string_literal: true

module Organized
  class TimeEntriesController < BaseController
    before_action :set_time_view, only: %i[new create]

    def new
      @time_entry = TimeEntry.new executed_on: @time_view.date, user: impersonating_or_current_user
      authorize @time_entry
      fill_available_projects_and_tasks @time_entry
      respond_with current_organization, @time_entry
    end

    def create
      @time_entry = TimeEntry.new create_params
      authorize @time_entry
      @time_entry.save
      fill_available_projects_and_tasks(@time_entry) unless @time_entry.valid?
      respond_with current_organization, @time_entry,
                   location: -> { after_create_or_update_path @time_entry }
    end

    def edit
      @time_entry = current_organization.time_entries.find params[:id]
      authorize @time_entry
      fill_available_projects_and_tasks(@time_entry)
      respond_with current_organization, @time_entry
    end

    def update
      @time_entry = current_organization.time_entries.find params[:id]
      authorize @time_entry
      @time_entry.update_attributes update_params
      fill_available_projects_and_tasks(@time_entry) unless @time_entry.valid?
      respond_with current_organization, @time_entry,
                   location: -> { after_create_or_update_path @time_entry }
    end

    def destroy
      @time_entry = current_organization.time_entries.find params[:id]
      authorize @time_entry
      @time_entry.destroy
      respond_with current_organization, @time_entry,
                   location: -> { after_create_or_update_path @time_entry }
    end

    private

    def after_create_or_update_path time_entry
      options = {
        as: time_entry.user != current_user ? time_entry.user.id : nil
      }
      organization_time_view_path current_organization, time_entry.time_view, options
    end

    def create_params
      params.require(:time_entry).permit(:user_id, :project_id, :task_id, :notes,
                                         :time_amount)
            .merge(executed_on: @time_view.date)
            .reverse_merge(user_id: current_user.id)
    end

    def update_params
      params.require(:time_entry).permit(:project_id, :task_id, :notes, :time_amount,
                                         :executed_on)
    end

    def set_time_view
      @time_view = TimeView.find params[:time_view_id], current_organization, current_user
    end

    def impersonating_user
      return nil unless params[:as]
      @impersonating_user ||= current_organization.users.find params[:as]
    rescue ActiveRecord::RecordNotFound
      nil
    end

    def impersonating_or_current_user
      impersonating_user || current_user
    end

    def fill_available_projects_and_tasks time_entry
      @projects = available_projects_for time_entry.user
      project_for_tasks = time_entry.project || @projects.first
      @tasks = project_for_tasks ? project_for_tasks.tasks.by_name : []
    end
  end
end
