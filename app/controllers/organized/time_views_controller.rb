# frozen_string_literal: true

module Organized
  class TimeViewsController < BaseController
    def show
      @week_time_views = TimeView.find_week_including params[:id], current_organization
      @time_view = @week_time_views.detect { |view| view.id == params[:id] }
      @total_in_week = TimeEntry.in_time_view_week_including(@time_view).sum(:minutes)
    end
  end
end
