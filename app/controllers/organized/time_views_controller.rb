# frozen_string_literal: true

module Organized
  class TimeViewsController < BaseController
    def show
      @week_view = WeekView.find_by_time_view_id params[:id], current_organization
      @time_view = @week_view.selected_time_view
    end
  end
end
