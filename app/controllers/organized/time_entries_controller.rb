# frozen_string_literal: true

module Organized
  class TimeEntriesController < BaseController
    before_action :set_time_view

    helper_method :current_time_view

    def new
      @time_entry = current_user.time_entries.build executed_on: current_time_view.date
      respond_with @time_entry
    end

    def create
      @time_entry = current_user.time_entries.create time_entry_params
      respond_with @time_entry, location: -> { [current_organization, current_time_view] }
    end

    private

    def time_entry_params
      params.require(:time_entry).permit(:project_id, :minutes)
            .merge(executed_on: current_time_view.date)
    end

    def current_time_view
      @time_view
    end

    def set_time_view
      @time_view = TimeView.find params[:time_view_id], current_organization
    end
  end
end
