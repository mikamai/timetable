# frozen_string_literal: true

module Organized
  class TimeEntriesController < BaseController
    before_action :set_time_view, only: %i[new create]

    def new
      @time_entry = current_user.time_entries.build executed_on: @time_view.date
      respond_with @time_entry
    end

    def create
      @time_entry = current_user.time_entries.create create_params
      respond_with @time_entry, location: -> { [current_organization, @time_entry.time_view] }
    end

    def edit
      @time_entry = current_user.time_entries.in_organization(current_organization).find params[:id]
      respond_with @time_entry
    end

    def update
      @time_entry = current_user.time_entries.in_organization(current_organization).find params[:id]
      @time_entry.update_attributes update_params
      respond_with @time_entry, location: -> { [current_organization, @time_entry.time_view] }
    end

    private

    def create_params
      params.require(:time_entry).permit(:task_id, :notes, :minutes_in_distance)
            .merge(executed_on: @time_view.date)
    end

    def update_params
      params.require(:time_entry).permit(:executed_on, :task_id, :notes, :minutes_in_distance)
    end

    def set_time_view
      @time_view = TimeView.find params[:time_view_id], current_organization
    end
  end
end
